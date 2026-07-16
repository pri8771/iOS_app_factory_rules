# iOS App Factory Rules

Central operating system for AI-assisted iOS, iPadOS, macOS, and web application development.

This repository is the canonical source of truth for studio-wide engineering standards, quality rules, project registration, agent behavior, reusable templates, and verification requirements.

## How an agent recognizes a project

A project is registered when it contains:

```text
.factory/project-context.json
.factory/standard-lock.json
.factory/AGENTS.factory.md
quality/quality-manifest.json
```

The `projectType` field in `.factory/project-context.json` is authoritative:

- `new`: a new project being planned or scaffolded;
- `existing`: an existing codebase being brought under the factory standards.

Agents must not guess the project type from repository size or documentation completeness.

## Supported agent entry points

| Tool | Entry file installed in each project |
|---|---|
| Codex and generic agents | `AGENTS.md` |
| Claude Code | `CLAUDE.md` |
| Gemini | `GEMINI.md` |
| Cursor | `.cursor/rules/app-factory.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Canonical local minimum standard | `.factory/AGENTS.factory.md` |

All entry files point to the same machine-readable project context and quality manifest.

## Start here

- IDE and agent setup: [`docs/IDE_AGENT_SETUP.md`](docs/IDE_AGENT_SETUP.md)
- New project: [`playbooks/START_NEW_PROJECT.md`](playbooks/START_NEW_PROJECT.md)
- Existing project: [`playbooks/REGISTER_EXISTING_PROJECT.md`](playbooks/REGISTER_EXISTING_PROJECT.md)
- Agent detection rules: [`playbooks/AGENT_PROJECT_DETECTION.md`](playbooks/AGENT_PROJECT_DETECTION.md)
- Quality rulebook: [`standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md`](standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md)

## Install into a project

### New project

```bash
./scripts/bootstrap-project.sh \
  --target /path/to/project \
  --mode new \
  --name "My App" \
  --platforms ios,ipados
```

### Existing project

```bash
./scripts/bootstrap-project.sh \
  --target /path/to/project \
  --mode existing \
  --name "Existing App" \
  --platforms ios,macos
```

The script preserves existing documentation and agent instructions. When an entry file already exists, it adds only a managed reference block rather than replacing the file.

Verify a registered project with:

```bash
./scripts/verify-project-registration.sh /path/to/project
```

## Repository model

This repository stores universal standards. Each app repository stores its own product facts, architecture, decisions, contracts, evidence, and a lock to a specific standards version.

```text
iOS_app_factory_rules
        ├── App repository A
        ├── App repository B
        └── Web repository C
```

Current standard version: `0.2.0`
