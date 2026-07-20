# IDE and Agent Setup

The factory uses one machine-readable project marker plus tool-specific entry files.

## Authoritative project marker

Every registered application repository must contain:

```text
.factory/project-context.json
```

The `projectType` field is authoritative:

```json
"projectType": "new"
```

or:

```json
"projectType": "existing"
```

Do not rely on an agent guessing from repository size, commit history, or how complete the documentation appears.

## Tool entry files

| Tool or agent | Local entry file |
|---|---|
| Codex and generic agents | `AGENTS.md` |
| Claude Code | `CLAUDE.md` |
| Gemini CLI or agent | `GEMINI.md` |
| Cursor | `.cursor/rules/app-factory.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Every tool | `.factory/AGENTS.factory.md` and `.factory/project-context.json` |

Each adapter points to the same local project context and minimum standard. Do not maintain separate behavioral rules for each tool.

## New project

Run:

```bash
./scripts/bootstrap-project.sh \
  --target /path/to/project \
  --mode new \
  --name "App Name" \
  --platforms ios,ipados
```

The project starts at `planned`, and agents are instructed to define scope, architecture, quality requirements, and initial feature contracts before broad implementation.

## Existing project

Run:

```bash
./scripts/bootstrap-project.sh \
  --target /path/to/project \
  --mode existing \
  --name "App Name" \
  --platforms ios,macos
```

The project starts at `onboarding_existing`, and agents are instructed to inventory and baseline the codebase before restructuring it.

## Upgrade

Run when a registered project's `.factory/standard-lock.json` is behind the current central `VERSION`:

```bash
./scripts/upgrade-project.sh --target /path/to/project
```

Upgrade refreshes central-controlled files, forward-fills any required registration file the project is missing, and never overwrites product-authored documentation or a customized `.factory/repository-map.json`. Add `--dry-run` to preview first. See `playbooks/UPGRADE_REGISTERED_PROJECT.md`.

## Verification

From this repository, run:

```bash
./scripts/verify-project-registration.sh /path/to/project
```

The verifier checks the required files and confirms that the project name and type agree between the project context and quality manifest.

## Existing instruction files

The bootstrap process must not silently replace existing agent instructions. It appends a small managed reference block when an entry file already exists and installs the detailed minimum standard in `.factory/AGENTS.factory.md`.
