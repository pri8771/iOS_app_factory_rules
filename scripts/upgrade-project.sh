#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  upgrade-project.sh --target PATH [--dry-run]

Brings an already-registered product repository's central-controlled
registration files up to date with the current App Factory standard.
Never overwrites product-authored documentation, source code, or a
repository map the product has already customized.

Examples:
  ./scripts/upgrade-project.sh --target ../Japa
  ./scripts/upgrade-project.sh --target ../Japa --dry-run
EOF
}

TARGET=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$TARGET" ]] || { usage; exit 2; }
[[ -d "$TARGET" ]] || { echo "Target directory does not exist: $TARGET" >&2; exit 2; }

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$(cd "$TARGET" && pwd)"
TEMPLATE="$ROOT/templates/project"
DATE="$(date -u +%Y-%m-%d)"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"

if [[ ! -f "$TARGET/.factory/project-context.json" ]]; then
  echo "Not a registered project: $TARGET" >&2
  echo "Use scripts/bootstrap-project.sh or scripts/remote-init.sh to register it first." >&2
  exit 3
fi

if [[ ! -f "$TARGET/.factory/standard-lock.json" ]]; then
  echo "Registered project is missing .factory/standard-lock.json; cannot determine installed version: $TARGET" >&2
  exit 4
fi

python3 - "$TARGET" "$TEMPLATE" "$ROOT" "$DATE" "$VERSION" "$DRY_RUN" <<'PY'
import json
import pathlib
import shutil
import sys

target = pathlib.Path(sys.argv[1])
template = pathlib.Path(sys.argv[2])
root = pathlib.Path(sys.argv[3])
date = sys.argv[4]
version = sys.argv[5]
dry_run = sys.argv[6] == "1"

lock_path = target / ".factory/standard-lock.json"
lock = json.loads(lock_path.read_text())
old_version = lock.get("standardVersion", "unknown")

catalog_path = target / ".factory/library-catalog.json"
old_catalog_version = (
    json.loads(catalog_path.read_text()).get("catalogVersion") if catalog_path.exists() else None
)
new_catalog = json.loads((root / "registry/libraries.json").read_text())
new_catalog_version = new_catalog["catalogVersion"]

repo_map_path = target / ".factory/repository-map.json"
repo_map_schema_version = (
    json.loads(repo_map_path.read_text()).get("schemaVersion") if repo_map_path.exists() else None
)
template_schema_version = json.loads((template / ".factory/repository-map.json").read_text()).get("schemaVersion")

# Files bootstrap-project.sh always installs on first registration. Forward-fill
# whichever are missing so an older registration catches up; never overwrite
# a file that already exists, since it may carry product customization.
copy_if_absent = [
    (".factory/AGENTS.factory.md", template / ".factory/AGENTS.factory.md"),
    (".factory/repository-map.json", template / ".factory/repository-map.json"),
    ("quality/evidence/README.md", template / "quality/evidence/README.md"),
    ("quality/waivers/README.md", template / "quality/waivers/README.md"),
    ("quality/feature-contracts/EXAMPLE.json", template / "quality/feature-contracts/EXAMPLE.json"),
    ("quality/completion-reports/EXAMPLE.json", template / "quality/completion-reports/EXAMPLE.json"),
    (".cursor/rules/app-factory.mdc", template / ".cursor/rules/app-factory.mdc"),
]
for doc in [
    "README.md", "STATUS.md", "ARCHITECTURE.md", "FEATURES.md", "BUGS.md",
    "DECISIONS.md", "RISKS.md", "ASSUMPTIONS.md", "TEST_PLAN.md",
    "RELEASE_CHECKLIST.md", "HANDOFF.md", "REUSABLE_COMPONENTS.md",
]:
    copy_if_absent.append((f"docs/{doc}", template / "docs" / doc))

managed_block = (
    "<!-- APP-FACTORY:BEGIN -->\n"
    "## App Factory Registration\n\n"
    "Use the shortest reliable context path before editing:\n\n"
    "`AGENTS.md → .factory/repository-map.json → .factory/project-context.json → docs/README.md → task-relevant canonical documents`\n\n"
    "Read `.factory/library-catalog.json` before implementing cross-cutting infrastructure. "
    "The `projectType` field is authoritative. Do not read the entire repository by default, "
    "create duplicate sources of truth, or mark work done without required evidence.\n"
    "<!-- APP-FACTORY:END -->\n"
)
entry_files = [
    ("AGENTS.md", template / "AGENTS.md"),
    ("CLAUDE.md", template / "CLAUDE.md"),
    ("GEMINI.md", template / "GEMINI.md"),
    (".github/copilot-instructions.md", template / ".github/copilot-instructions.md"),
]

created = []
appended = []
for relative, source in copy_if_absent:
    destination = target / relative
    if not destination.exists():
        created.append(relative)
        if not dry_run:
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(source, destination)

for relative, source in entry_files:
    destination = target / relative
    if not destination.exists():
        created.append(relative)
        if not dry_run:
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(source, destination)
    elif "<!-- APP-FACTORY:BEGIN -->" not in destination.read_text():
        appended.append(relative)
        if not dry_run:
            with destination.open("a") as handle:
                handle.write("\n\n" + managed_block)

warnings = []
if repo_map_schema_version and repo_map_schema_version != template_schema_version:
    warnings.append(
        f".factory/repository-map.json schemaVersion {repo_map_schema_version} is behind "
        f"the current template schemaVersion {template_schema_version}; review "
        "templates/project/.factory/repository-map.json in the central repository and merge "
        "any new fields manually."
    )

version_changed = old_version != version
catalog_changed = old_catalog_version != new_catalog_version
lock_needs_rewrite = version_changed or catalog_changed

if not dry_run:
    if catalog_changed:
        catalog_path.write_text(json.dumps(new_catalog, indent=2) + "\n")
    if lock_needs_rewrite:
        new_lock = dict(lock)
        new_lock["$schema"] = (
            "https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/schemas/standard-lock.schema.json"
        )
        new_lock["standardVersion"] = version
        new_lock["libraryCatalogVersion"] = new_catalog_version
        new_lock["upgradedAt"] = date
        if version_changed:
            new_lock["previousStandardVersion"] = old_version
        lock_path.write_text(json.dumps(new_lock, indent=2) + "\n")

already_up_to_date = not (created or appended or lock_needs_rewrite)

print(f"Target: {target}")
print(f"Standard version: {old_version} -> {version}")
print(f"Library catalog version: {old_catalog_version} -> {new_catalog_version}")
if dry_run:
    print("Dry run: no files were written.")
if already_up_to_date:
    print("Already up to date. No changes were needed.")
if created:
    verb = "Would create" if dry_run else "Created"
    print(f"{verb} missing required files:")
    for path in created:
        print(f"  - {path}")
if appended:
    verb = "Would append" if dry_run else "Appended"
    print(f"{verb} the App Factory managed block to entry files missing it:")
    for path in appended:
        print(f"  - {path}")
for warning in warnings:
    print(f"Warning: {warning}")
PY

if [[ "$DRY_RUN" -eq 1 ]]; then
  exit 0
fi

"$ROOT/scripts/verify-project-registration.sh" "$TARGET"
echo "Upgrade complete for $TARGET"
