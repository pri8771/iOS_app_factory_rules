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
    target / ".factory/project-context.json",
    target / ".factory/standard-lock.json",
    target / ".factory/AGENTS.factory.md",
    target / "quality/quality-manifest.json",
]
missing = [str(path.relative_to(target)) for path in required if not path.exists()]
if missing:
    raise SystemExit("Unregistered or incomplete project; missing: " + ", ".join(missing))

context = json.loads((target / ".factory/project-context.json").read_text())
manifest = json.loads((target / "quality/quality-manifest.json").read_text())
if context.get("projectType") not in {"new", "existing"}:
    raise SystemExit("projectType must be 'new' or 'existing'")
if context.get("projectName") != manifest.get("application", {}).get("name"):
    raise SystemExit("Project name differs between project context and quality manifest")
if context.get("projectType") != manifest.get("application", {}).get("projectType"):
    raise SystemExit("Project type differs between project context and quality manifest")
print(f"Registered: {context['projectName']} ({context['projectType']})")
print("Platforms: " + ", ".join(context.get("platforms", [])))
print("Lifecycle: " + context.get("lifecycleStatus", "unknown"))
PY
