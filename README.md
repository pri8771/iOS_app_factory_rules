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
AGENTS.md
```

The `projectType` field in `.factory/project-context.json` is authoritative:

- `new`: a new project being planned or scaffolded;
- `existing`: an existing codebase being brought under the factory standards.

Agents must read `AGENTS.md` and `.factory/project-context.json` before editing code.

## Start here

- New project: [`playbooks/START_NEW_PROJECT.md`](playbooks/START_NEW_PROJECT.md)
- Existing project: [`playbooks/REGISTER_EXISTING_PROJECT.md`](playbooks/REGISTER_EXISTING_PROJECT.md)
- Agent detection rules: [`playbooks/AGENT_PROJECT_DETECTION.md`](playbooks/AGENT_PROJECT_DETECTION.md)
- Quality rulebook: [`standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md`](standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md)

## Install into a project

```bash
./scripts/bootstrap-project.sh \
  --target /path/to/project \
  --mode new \
  --name "My App" \
  --platforms ios,ipados
```

For an existing repository:

```bash
./scripts/bootstrap-project.sh \
  --target /path/to/project \
  --mode existing \
  --name "Existing App" \
  --platforms ios,macos
```

The script does not overwrite existing project documents. It adds a small managed block to an existing `AGENTS.md` when necessary.

## Repository model

This repository stores universal standards. Each app repository stores its own product facts, architecture, decisions, contracts, evidence, and a lock to a specific standards version.

```text
iOS_app_factory_rules
        ├── App repository A
        ├── App repository B
        └── Web repository C
```

Current standard version: `0.1.0`
