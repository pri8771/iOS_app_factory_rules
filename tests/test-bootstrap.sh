#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

NEW_PROJECT="$TMP/new-project"
EXISTING_PROJECT="$TMP/existing-project"
mkdir -p "$NEW_PROJECT" "$EXISTING_PROJECT"

printf '# Existing generic instructions\n' > "$EXISTING_PROJECT/AGENTS.md"
printf '# Existing Claude instructions\n' > "$EXISTING_PROJECT/CLAUDE.md"
printf 'existing application source\n' > "$EXISTING_PROJECT/App.swift"

"$ROOT/scripts/bootstrap-project.sh" \
  --target "$NEW_PROJECT" \
  --mode new \
  --name "New Test App" \
  --platforms ios,ipados

"$ROOT/scripts/verify-project-registration.sh" "$NEW_PROJECT"

"$ROOT/scripts/bootstrap-project.sh" \
  --target "$EXISTING_PROJECT" \
  --mode existing \
  --name "Existing Test App" \
  --platforms ios,macos

"$ROOT/scripts/verify-project-registration.sh" "$EXISTING_PROJECT"

grep -q '# Existing generic instructions' "$EXISTING_PROJECT/AGENTS.md"
grep -q '# Existing Claude instructions' "$EXISTING_PROJECT/CLAUDE.md"
grep -q '<!-- APP-FACTORY:BEGIN -->' "$EXISTING_PROJECT/AGENTS.md"
grep -q '<!-- APP-FACTORY:BEGIN -->' "$EXISTING_PROJECT/CLAUDE.md"
test -f "$EXISTING_PROJECT/App.swift"

python3 - "$NEW_PROJECT" "$EXISTING_PROJECT" <<'PY'
import json
import pathlib
import sys

new = pathlib.Path(sys.argv[1])
existing = pathlib.Path(sys.argv[2])

new_context = json.loads((new / ".factory/project-context.json").read_text())
existing_context = json.loads((existing / ".factory/project-context.json").read_text())

assert new_context["projectType"] == "new"
assert new_context["existingCodeBaselineRequired"] is False
assert existing_context["projectType"] == "existing"
assert existing_context["existingCodeBaselineRequired"] is True
assert set(existing_context["agentEntryPoints"]) == {
    "generic",
    "claudeCode",
    "gemini",
    "cursor",
    "githubCopilot",
    "canonicalLocalRules",
}
PY

echo "Bootstrap integration test passed."
