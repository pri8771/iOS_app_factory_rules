#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PROJECT="$TMP/project"
mkdir -p "$PROJECT"

"$ROOT/scripts/bootstrap-project.sh" \
  --target "$PROJECT" \
  --mode new \
  --name "Upgrade Test App" \
  --platforms ios,ipados

"$ROOT/scripts/verify-project-registration.sh" "$PROJECT"

CURRENT_VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"

python3 - "$PROJECT" <<'PY'
import json
import pathlib
import sys

project = pathlib.Path(sys.argv[1])

lock_path = project / ".factory/standard-lock.json"
lock = json.loads(lock_path.read_text())
lock["standardVersion"] = "0.0.1"
lock["libraryCatalogVersion"] = "0.0.0"
lock.pop("$schema", None)
lock.pop("upgradedAt", None)
lock.pop("previousStandardVersion", None)
lock_path.write_text(json.dumps(lock, indent=2) + "\n")

catalog_path = project / ".factory/library-catalog.json"
catalog = json.loads(catalog_path.read_text())
catalog["catalogVersion"] = "0.0.0"
catalog_path.write_text(json.dumps(catalog, indent=2) + "\n")

(project / "docs/HANDOFF.md").unlink()

status_path = project / "docs/STATUS.md"
status_path.write_text(status_path.read_text() + "\nPRESERVE-THIS-PRODUCT-CONTENT\n")
PY

# A repository not yet registered must be rejected, not silently scaffolded.
UNREGISTERED="$TMP/unregistered"
mkdir -p "$UNREGISTERED"
if "$ROOT/scripts/upgrade-project.sh" --target "$UNREGISTERED" 2>/dev/null; then
  echo "upgrade-project.sh must fail against an unregistered target" >&2
  exit 1
fi

# Dry run must report the plan without writing anything.
"$ROOT/scripts/upgrade-project.sh" --target "$PROJECT" --dry-run
if [[ -f "$PROJECT/docs/HANDOFF.md" ]]; then
  echo "dry run must not create files" >&2
  exit 1
fi
python3 - "$PROJECT" <<'PY'
import json
import pathlib
import sys

project = pathlib.Path(sys.argv[1])
lock = json.loads((project / ".factory/standard-lock.json").read_text())
assert lock["standardVersion"] == "0.0.1", "dry run must not modify the standard lock"
PY

# Real upgrade must forward-fill missing files, refresh central metadata, and
# leave product-authored content untouched.
"$ROOT/scripts/upgrade-project.sh" --target "$PROJECT"

test -f "$PROJECT/docs/HANDOFF.md"
grep -q 'PRESERVE-THIS-PRODUCT-CONTENT' "$PROJECT/docs/STATUS.md"

python3 - "$PROJECT" "$ROOT" "$CURRENT_VERSION" <<'PY'
import json
import pathlib
import sys

project = pathlib.Path(sys.argv[1])
root = pathlib.Path(sys.argv[2])
current_version = sys.argv[3]

lock = json.loads((project / ".factory/standard-lock.json").read_text())
assert lock["standardVersion"] == current_version, lock["standardVersion"]
assert lock["previousStandardVersion"] == "0.0.1", lock.get("previousStandardVersion")
assert "upgradedAt" in lock
assert lock["$schema"].endswith("standard-lock.schema.json")

catalog = json.loads((project / ".factory/library-catalog.json").read_text())
registry_catalog = json.loads((root / "registry/libraries.json").read_text())
assert catalog["catalogVersion"] == registry_catalog["catalogVersion"]
assert lock["libraryCatalogVersion"] == registry_catalog["catalogVersion"]
PY

"$ROOT/scripts/verify-project-registration.sh" "$PROJECT"

# Re-running the upgrade must be a no-op: idempotent, no further drift.
BEFORE_LOCK="$(cat "$PROJECT/.factory/standard-lock.json")"
SECOND_RUN_OUTPUT="$("$ROOT/scripts/upgrade-project.sh" --target "$PROJECT")"
grep -q 'Already up to date' <<<"$SECOND_RUN_OUTPUT"
AFTER_LOCK="$(cat "$PROJECT/.factory/standard-lock.json")"
[[ "$BEFORE_LOCK" == "$AFTER_LOCK" ]]

echo "Upgrade integration test passed."
