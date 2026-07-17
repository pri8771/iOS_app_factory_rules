#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bootstrap-project.sh --target PATH --mode new|existing --name NAME --platforms csv

Examples:
  ./scripts/bootstrap-project.sh --target ../NewApp --mode new --name "New App" --platforms ios,ipados
  ./scripts/bootstrap-project.sh --target ../ExistingApp --mode existing --name "Existing App" --platforms ios,macos
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

mkdir -p \
  "$TARGET/.factory" \
  "$TARGET/.cursor/rules" \
  "$TARGET/.github" \
  "$TARGET/quality/feature-contracts" \
  "$TARGET/quality/completion-reports" \
  "$TARGET/quality/evidence" \
  "$TARGET/quality/waivers" \
  "$TARGET/docs"

[[ -e "$TARGET/.factory/AGENTS.factory.md" ]] || cp "$TEMPLATE/.factory/AGENTS.factory.md" "$TARGET/.factory/AGENTS.factory.md"
[[ -e "$TARGET/.factory/repository-map.json" ]] || cp "$TEMPLATE/.factory/repository-map.json" "$TARGET/.factory/repository-map.json"
[[ -e "$TARGET/.factory/library-catalog.json" ]] || cp "$ROOT/registry/libraries.json" "$TARGET/.factory/library-catalog.json"
[[ -e "$TARGET/quality/evidence/README.md" ]] || cp "$TEMPLATE/quality/evidence/README.md" "$TARGET/quality/evidence/README.md"
[[ -e "$TARGET/quality/waivers/README.md" ]] || cp "$TEMPLATE/quality/waivers/README.md" "$TARGET/quality/waivers/README.md"

for file in README.md STATUS.md ARCHITECTURE.md FEATURES.md BUGS.md DECISIONS.md RISKS.md ASSUMPTIONS.md TEST_PLAN.md RELEASE_CHECKLIST.md HANDOFF.md REUSABLE_COMPONENTS.md; do
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
catalog = json.loads((target / ".factory/library-catalog.json").read_text())

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
    "libraryDiscovery": {
        "policy": "reuse_first",
        "localCatalog": ".factory/library-catalog.json",
        "centralCatalog": "pri8771/iOS_app_factory_rules/registry/libraries.json",
        "reusableComponentsDocument": "docs/REUSABLE_COMPONENTS.md",
    },
    "agentEntryPoints": {
        "generic": "AGENTS.md",
        "claudeCode": "CLAUDE.md",
        "gemini": "GEMINI.md",
        "cursor": ".cursor/rules/app-factory.mdc",
        "githubCopilot": ".github/copilot-instructions.md",
        "canonicalLocalRules": ".factory/AGENTS.factory.md",
    },
    "requiredReading": [
        "AGENTS.md",
        ".factory/repository-map.json",
        ".factory/project-context.json",
        ".factory/standard-lock.json",
        ".factory/AGENTS.factory.md",
        ".factory/library-catalog.json",
        "docs/README.md",
        "quality/quality-manifest.json",
    ],
}
lock = {
    "standardRepository": "pri8771/iOS_app_factory_rules",
    "standardRepositoryUrl": "https://github.com/pri8771/iOS_app_factory_rules",
    "standardVersion": version,
    "standardRef": "main",
    "profiles": ["common"] + platforms,
    "repositoryMapVersion": "1.0.0",
    "repositoryMapPath": ".factory/repository-map.json",
    "libraryCatalogVersion": catalog["catalogVersion"],
    "libraryCatalogPath": ".factory/library-catalog.json",
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

for relative in ["docs/README.md"]:
    path = target / relative
    path.write_text(path.read_text().replace("REPLACE_DATE", date))
PY

read -r -d '' AGENT_BLOCK <<'EOF' || true
<!-- APP-FACTORY:BEGIN -->
## App Factory Registration

Use the shortest reliable context path before editing:

`AGENTS.md → .factory/repository-map.json → .factory/project-context.json → docs/README.md → task-relevant canonical documents`

Read `.factory/library-catalog.json` before implementing cross-cutting infrastructure. The `projectType` field is authoritative. Do not read the entire repository by default, create duplicate sources of truth, or mark work done without required evidence.
<!-- APP-FACTORY:END -->
EOF

install_entry_file() {
  local source="$1"
  local destination="$2"

  if [[ ! -e "$destination" ]]; then
    cp "$source" "$destination"
  elif ! grep -q '<!-- APP-FACTORY:BEGIN -->' "$destination"; then
    printf '\n\n%s\n' "$AGENT_BLOCK" >> "$destination"
  fi
}

install_entry_file "$TEMPLATE/AGENTS.md" "$TARGET/AGENTS.md"
install_entry_file "$TEMPLATE/CLAUDE.md" "$TARGET/CLAUDE.md"
install_entry_file "$TEMPLATE/GEMINI.md" "$TARGET/GEMINI.md"
install_entry_file "$TEMPLATE/.github/copilot-instructions.md" "$TARGET/.github/copilot-instructions.md"

if [[ ! -e "$TARGET/.cursor/rules/app-factory.mdc" ]]; then
  cp "$TEMPLATE/.cursor/rules/app-factory.mdc" "$TARGET/.cursor/rules/app-factory.mdc"
fi

python3 - "$TARGET" "$MODE" <<'PY'
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
mode = sys.argv[2]
path = target / "docs/STATUS.md"
text = path.read_text()
text = text.replace("`planned`", "`onboarding_existing`" if mode == "existing" else "`planned`", 1)
path.write_text(text)
PY

echo "Registered $NAME as a $MODE project at $TARGET"
echo "Installed LLM navigation, agent entry points, quality files, and reusable-library catalog snapshot."
echo "Next: populate .factory/repository-map.json and begin with docs/README.md"
