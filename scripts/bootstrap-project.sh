#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bootstrap-project.sh --target PATH --mode new|existing --name NAME --platforms csv

Example:
  ./scripts/bootstrap-project.sh --target ../MyApp --mode existing --name "My App" --platforms ios,macos
EOF
}

TARGET=""
MODE=""
NAME=""
PLATFORMS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --platforms) PLATFORMS="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$TARGET" && -n "$MODE" && -n "$NAME" && -n "$PLATFORMS" ]] || { usage; exit 2; }
[[ "$MODE" == "new" || "$MODE" == "existing" ]] || { echo "--mode must be new or existing" >&2; exit 2; }
[[ -d "$TARGET" ]] || { echo "Target directory does not exist: $TARGET" >&2; exit 2; }

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$(cd "$TARGET" && pwd)"
TEMPLATE="$ROOT/templates/project"
DATE="$(date -u +%Y-%m-%d)"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"

if [[ -f "$TARGET/.factory/project-context.json" ]]; then
  echo "Project is already registered: $TARGET" >&2
  exit 3
fi

mkdir -p "$TARGET/.factory" "$TARGET/quality/feature-contracts" "$TARGET/quality/completion-reports" "$TARGET/quality/evidence" "$TARGET/quality/waivers" "$TARGET/docs"

cp "$TEMPLATE/.factory/AGENTS.factory.md" "$TARGET/.factory/AGENTS.factory.md"
cp "$TEMPLATE/quality/evidence/README.md" "$TARGET/quality/evidence/README.md"
cp "$TEMPLATE/quality/waivers/README.md" "$TARGET/quality/waivers/README.md"

for file in STATUS.md ARCHITECTURE.md FEATURES.md BUGS.md DECISIONS.md RISKS.md ASSUMPTIONS.md TEST_PLAN.md RELEASE_CHECKLIST.md HANDOFF.md; do
  [[ -e "$TARGET/docs/$file" ]] || cp "$TEMPLATE/docs/$file" "$TARGET/docs/$file"
done

[[ -e "$TARGET/quality/feature-contracts/EXAMPLE.json" ]] || cp "$TEMPLATE/quality/feature-contracts/EXAMPLE.json" "$TARGET/quality/feature-contracts/EXAMPLE.json"
[[ -e "$TARGET/quality/completion-reports/EXAMPLE.json" ]] || cp "$TEMPLATE/quality/completion-reports/EXAMPLE.json" "$TARGET/quality/completion-reports/EXAMPLE.json"

python3 - "$TARGET" "$MODE" "$NAME" "$PLATFORMS" "$DATE" "$VERSION" <<'PY'
import json
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
mode = sys.argv[2]
name = sys.argv[3]
platforms = [p.strip() for p in sys.argv[4].split(',') if p.strip()]
date = sys.argv[5]
version = sys.argv[6]

context = {
    "$schema": "https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/schemas/project-context.schema.json",
    "projectName": name,
    "projectType": mode,
    "lifecycleStatus": "planned" if mode == "new" else "onboarding_existing",
    "platforms": platforms,
    "frameworks": [],
    "registeredAt": date,
    "existingCodeBaselineRequired": mode == "existing",
    "constraints": {
        "localFirst": True,
        "backendAllowed": False,
        "thirdPartyDependenciesAllowed": False,
    },
    "requiredReading": [
        "AGENTS.md",
        ".factory/AGENTS.factory.md",
        "quality/quality-manifest.json",
        "docs/STATUS.md",
        "docs/ARCHITECTURE.md",
        "docs/BUGS.md",
        "docs/DECISIONS.md",
    ],
}
lock = {
    "standardRepository": "pri8771/iOS_app_factory_rules",
    "standardRepositoryUrl": "https://github.com/pri8771/iOS_app_factory_rules",
    "standardVersion": version,
    "standardRef": "main",
    "profiles": ["common"] + platforms,
    "installedAt": date,
}
manifest = {
    "$schema": "https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/schemas/quality-manifest.schema.json",
    "application": {"name": name, "projectType": mode, "platforms": platforms},
    "requirements": {
        "accessibility": True,
        "responsiveLayoutTests": True,
        "darkMode": True,
        "persistenceRelaunchTests": True,
        "fakeDataIsolation": True,
        "completionEvidence": True,
    },
    "requiredTestSuites": ["unit", "integration", "ui-smoke"],
    "qualityStandardVersion": version,
}
for path, value in [
    (target / ".factory/project-context.json", context),
    (target / ".factory/standard-lock.json", lock),
    (target / "quality/quality-manifest.json", manifest),
]:
    path.write_text(json.dumps(value, indent=2) + "\n")
PY

AGENT_BLOCK='<!-- APP-FACTORY:BEGIN -->
## App Factory Registration

Before editing this repository, read `.factory/project-context.json`, `.factory/AGENTS.factory.md`, `quality/quality-manifest.json`, and the relevant files in `docs/` and `quality/feature-contracts/`.

The `projectType` field is authoritative. Do not mark work done without required evidence.
<!-- APP-FACTORY:END -->'

if [[ ! -e "$TARGET/AGENTS.md" ]]; then
  cp "$TEMPLATE/AGENTS.md" "$TARGET/AGENTS.md"
elif ! grep -q '<!-- APP-FACTORY:BEGIN -->' "$TARGET/AGENTS.md"; then
  printf '\n\n%s\n' "$AGENT_BLOCK" >> "$TARGET/AGENTS.md"
fi

# Replace the obvious placeholders in files that were newly installed.
python3 - "$TARGET" "$NAME" "$MODE" <<'PY'
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
name = sys.argv[2]
mode = sys.argv[3]
for relative in ["docs/STATUS.md", "docs/FEATURES.md"]:
    path = target / relative
    text = path.read_text()
    text = text.replace("`planned`", "`onboarding_existing`" if mode == "existing" else "`planned`", 1)
    path.write_text(text)
PY

echo "Registered $NAME as a $MODE project at $TARGET"
echo "Next: review .factory/project-context.json and quality/quality-manifest.json"
