#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  remote-init.sh --target PATH --mode new|existing --name NAME --platforms csv [--ref REF]
  remote-init.sh --target PATH --mode upgrade [--ref REF] [--dry-run]

Examples:
  remote-init.sh --target . --mode new --name "New App" --platforms ios,ipados
  remote-init.sh --target ../Japa --mode existing --name "Japa" --platforms ios --ref main
  remote-init.sh --target ../Japa --mode upgrade
EOF
}

TARGET=""
MODE=""
NAME=""
PLATFORMS=""
REF="main"
DRY_RUN=0
REPOSITORY_URL="https://github.com/pri8771/iOS_app_factory_rules.git"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --platforms) PLATFORMS="$2"; shift 2 ;;
    --ref) REF="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$TARGET" && -n "$MODE" ]] || { usage; exit 2; }
[[ "$MODE" == "new" || "$MODE" == "existing" || "$MODE" == "upgrade" ]] || { echo "--mode must be new, existing, or upgrade" >&2; exit 2; }
if [[ "$MODE" == "new" || "$MODE" == "existing" ]]; then
  [[ -n "$NAME" && -n "$PLATFORMS" ]] || { echo "--name and --platforms are required for --mode $MODE" >&2; exit 2; }
fi
if [[ "$DRY_RUN" -eq 1 && "$MODE" != "upgrade" ]]; then
  echo "--dry-run is only supported with --mode upgrade; bootstrap has no dry-run mode" >&2
  exit 2
fi
[[ -d "$TARGET" ]] || { echo "Target directory does not exist: $TARGET" >&2; exit 2; }
command -v git >/dev/null 2>&1 || { echo "git is required" >&2; exit 2; }
command -v python3 >/dev/null 2>&1 || { echo "python3 is required" >&2; exit 2; }

TARGET="$(cd "$TARGET" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! git clone --quiet --depth 1 --branch "$REF" "$REPOSITORY_URL" "$TMP/rules"; then
  echo "Unable to fetch App Factory rules ref '$REF' from $REPOSITORY_URL" >&2
  exit 4
fi

if [[ "$MODE" == "upgrade" ]]; then
  UPGRADE_ARGS=(--target "$TARGET")
  [[ "$DRY_RUN" -eq 1 ]] && UPGRADE_ARGS+=(--dry-run)
  "$TMP/rules/scripts/upgrade-project.sh" "${UPGRADE_ARGS[@]}"
  echo "App Factory upgrade evaluated from ref: $REF"
  echo "Commit any changed .factory, quality, docs, or agent instruction files in the product repository."
  exit 0
fi

"$TMP/rules/scripts/bootstrap-project.sh" \
  --target "$TARGET" \
  --mode "$MODE" \
  --name "$NAME" \
  --platforms "$PLATFORMS"

"$TMP/rules/scripts/verify-project-registration.sh" "$TARGET"

echo "App Factory registration installed from ref: $REF"
echo "Commit the generated .factory, quality, docs, and agent instruction files in the product repository."
