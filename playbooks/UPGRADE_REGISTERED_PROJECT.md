---
id: PLAY-UPGRADE-REGISTERED-PROJECT
canonicalFor: registered-project-upgrade
status: active
lastVerified: 2026-07-17
readWhen:
  - bringing an already-registered product repository onto a newer standard version
  - the standard lock version is behind the current central VERSION
related:
  - playbooks/START_NEW_PROJECT.md
  - playbooks/REGISTER_EXISTING_PROJECT.md
  - governance/REPOSITORY_MODEL.md
supersedes: []
---

# Upgrade a Registered Project

Use this playbook when a product repository is already registered (`.factory/project-context.json` exists) and needs its central-controlled registration files brought up to date with the current App Factory standard.

## Upgrade safely

Run locally from a clone of this repository:

```bash
./scripts/upgrade-project.sh --target /path/to/repo
```

Or pull the current rules automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target /path/to/repo --mode upgrade
```

Preview the change first with `--dry-run` on either form. Nothing is written in dry-run mode.

## What upgrade changes

- `.factory/standard-lock.json` — regenerated with the current `standardVersion` and `libraryCatalogVersion`; the prior version is recorded as `previousStandardVersion` and the run is timestamped as `upgradedAt`.
- `.factory/library-catalog.json` — replaced with the current central catalog snapshot, since this file is always a mirror of `registry/libraries.json`, not product-customized content.
- Any required registration file that is missing (a doc, a quality directory placeholder, an agent entry file) is installed from the current template. Existing files are never overwritten.
- Any entry file (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`) that exists but does not yet carry the `<!-- APP-FACTORY:BEGIN -->` managed block gets the block appended, exactly like first-time bootstrap does for an existing project.

## What upgrade never touches

- Product documentation content (`docs/STATUS.md`, `docs/ARCHITECTURE.md`, feature contracts, decisions, and so on).
- Product source code.
- An existing `.factory/repository-map.json` — a product may have populated `sourceRoots`, `testRoots`, and other fields during onboarding. If the central repository-map schema has moved ahead of the installed file's `schemaVersion`, upgrade prints a warning naming the file to review rather than overwriting it.

## Idempotency

Running upgrade again when nothing changed prints `Already up to date` and writes nothing. It is always safe to re-run.

## After upgrading

1. Review any printed warnings, in particular a `.factory/repository-map.json` schema-version warning.
2. Run `./scripts/verify-project-registration.sh /path/to/repo` (upgrade already runs this automatically and will fail loudly if it does not pass).
3. Commit the changed `.factory` and any newly created files in the product repository.
4. Record the standard-version change in the product's `docs/DECISIONS.md` or `docs/STATUS.md` if it affects current work.
