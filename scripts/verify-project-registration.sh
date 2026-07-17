#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"
[[ -d "$TARGET" ]] || { echo "Directory not found: $TARGET" >&2; exit 2; }

python3 - "$TARGET" <<'PY'
import json
import pathlib
import sys

target = pathlib.Path(sys.argv[1])
required = [
    target / "AGENTS.md",
    target / "CLAUDE.md",
    target / "GEMINI.md",
    target / ".cursor/rules/app-factory.mdc",
    target / ".github/copilot-instructions.md",
    target / ".factory/project-context.json",
    target / ".factory/standard-lock.json",
    target / ".factory/library-catalog.json",
    target / ".factory/AGENTS.factory.md",
    target / "quality/quality-manifest.json",
    target / "docs/REUSABLE_COMPONENTS.md",
]
missing = [str(path.relative_to(target)) for path in required if not path.exists()]
if missing:
    raise SystemExit("Unregistered or incomplete project; missing: " + ", ".join(missing))

context = json.loads((target / ".factory/project-context.json").read_text())
lock = json.loads((target / ".factory/standard-lock.json").read_text())
manifest = json.loads((target / "quality/quality-manifest.json").read_text())
catalog = json.loads((target / ".factory/library-catalog.json").read_text())

if context.get("projectType") not in {"new", "existing"}:
    raise SystemExit("projectType must be 'new' or 'existing'")
if context.get("projectName") != manifest.get("application", {}).get("name"):
    raise SystemExit("Project name differs between project context and quality manifest")
if context.get("projectType") != manifest.get("application", {}).get("projectType"):
    raise SystemExit("Project type differs between project context and quality manifest")
if lock.get("standardVersion") != manifest.get("qualityStandardVersion"):
    raise SystemExit("Standard version differs between standard lock and quality manifest")
if lock.get("libraryCatalogVersion") != catalog.get("catalogVersion"):
    raise SystemExit("Library catalog version differs between standard lock and local catalog")

library_discovery = context.get("libraryDiscovery", {})
if library_discovery.get("localCatalog") != ".factory/library-catalog.json":
    raise SystemExit("Project context does not declare the local reusable-library catalog")

entry_points = context.get("agentEntryPoints", {})
for name, relative in entry_points.items():
    if not (target / relative).exists():
        raise SystemExit(f"Declared agent entry point is missing: {name} -> {relative}")

print(f"Registered: {context['projectName']} ({context['projectType']})")
print("Platforms: " + ", ".join(context.get("platforms", [])))
print("Lifecycle: " + context.get("lifecycleStatus", "unknown"))
print("Standard: " + lock.get("standardVersion", "unknown"))
print("Library catalog: " + catalog.get("catalogVersion", "unknown"))
print("Registered libraries: " + str(len(catalog.get("libraries", []))))
print("Agent entry points: " + ", ".join(sorted(entry_points)))
PY
