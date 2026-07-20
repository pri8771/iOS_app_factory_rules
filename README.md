# iOS App Factory Rules

Central control plane for AI-assisted iOS, iPadOS, macOS, and web application development.

This repository is the canonical source of truth for studio-wide engineering standards, quality rules, documentation policy, project registration, agent behavior, reusable-library discovery, templates, schemas, and verification requirements.

## LLM fast start

Agents should begin with [`LLM_START_HERE.md`](LLM_START_HERE.md), then read only the task-relevant standards or playbooks.

Registered product repositories use this context path:

```text
AGENTS.md
→ .factory/repository-map.json
→ .factory/project-context.json
→ docs/README.md
→ task-relevant canonical documents
```

The repository map and documentation index prevent agents from scanning the whole repository or loading overlapping documents by default.

## Repository model

Use:

- one repository per product;
- one repository per mature reusable library;
- this repository as the central rules, registry, documentation, and automation control plane.

Application source code does not live here. Japa, Hindsight, Jyot, and other products remain separate repositories. Shared package implementations receive dedicated repositories once they are mature enough to release independently.

See [`governance/REPOSITORY_MODEL.md`](governance/REPOSITORY_MODEL.md).

## How an agent recognizes a project

A registered product repository contains:

```text
.factory/repository-map.json
.factory/project-context.json
.factory/standard-lock.json
.factory/library-catalog.json
.factory/AGENTS.factory.md
docs/README.md
quality/quality-manifest.json
```

The `projectType` field in `.factory/project-context.json` is authoritative:

- `new`: a new product being planned or scaffolded;
- `existing`: an existing codebase being onboarded without an unsolicited rewrite.

## Agent entry points

| Tool | Project entry file |
|---|---|
| Codex and generic agents | `AGENTS.md` |
| Claude Code | `CLAUDE.md` |
| Gemini | `GEMINI.md` |
| Cursor | `.cursor/rules/app-factory.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Canonical local minimum standard | `.factory/AGENTS.factory.md` |

All entry files route agents through the same machine-readable repository map, project context, quality manifest, and reusable-library catalog.

## Automatically initialize a project

From inside a product repository:

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target "$PWD" --mode new --name "My App" --platforms ios,ipados
```

For an existing repository, use `--mode existing`.

The remote initializer clones a fresh temporary copy of this repository, runs the bootstrap, installs local navigation and agent files, copies a reusable-library catalog snapshot, and verifies registration. It does not move the app into this repository.

## Upgrade an already-registered project

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target "$PWD" --mode upgrade
```

Add `--dry-run` to preview the change first. Upgrade refreshes central-controlled files (`.factory/standard-lock.json`, `.factory/library-catalog.json`), forward-fills any required registration file the project is missing, and never overwrites product-authored documentation, source code, or a customized `.factory/repository-map.json`. It is idempotent — running it again with nothing to change reports `Already up to date`. See [`playbooks/UPGRADE_REGISTERED_PROJECT.md`](playbooks/UPGRADE_REGISTERED_PROJECT.md).

## Reuse-first development

Before implementing networking, persistence, StoreKit, export, logging, accessibility helpers, testing support, or other cross-cutting infrastructure, agents must inspect:

```text
.factory/library-catalog.json
docs/REUSABLE_COMPONENTS.md
```

If a suitable versioned library exists, use it through a thin product adapter. If none exists, implement a narrow library-ready local module and track it as a promotion candidate. Generic edge cases are contributed back through separate library and central-registry changes.

See:

- [`standards/engineering/MODULAR_LIBRARY_STANDARD.md`](standards/engineering/MODULAR_LIBRARY_STANDARD.md)
- [`standards/engineering/REUSE_FIRST_WORKFLOW.md`](standards/engineering/REUSE_FIRST_WORKFLOW.md)
- [`playbooks/PROMOTE_CODE_TO_SHARED_LIBRARY.md`](playbooks/PROMOTE_CODE_TO_SHARED_LIBRARY.md)
- [`registry/libraries.json`](registry/libraries.json)

## Documentation organization

The central documentation standard requires:

- one canonical owner per durable topic;
- small task-based reading routes;
- machine-readable repository maps;
- stable document IDs and headings;
- explicit facts, decisions, assumptions, and proposals;
- superseded-document tracking;
- current truth before history.

See [`standards/documentation/LLM_DOCUMENTATION_STANDARD.md`](standards/documentation/LLM_DOCUMENTATION_STANDARD.md).

## Start here

- LLM entrypoint: [`LLM_START_HERE.md`](LLM_START_HERE.md)
- Repository model: [`governance/REPOSITORY_MODEL.md`](governance/REPOSITORY_MODEL.md)
- New product repository: [`playbooks/CREATE_NEW_PRODUCT_REPOSITORY.md`](playbooks/CREATE_NEW_PRODUCT_REPOSITORY.md)
- Existing project onboarding: [`playbooks/REGISTER_EXISTING_PROJECT.md`](playbooks/REGISTER_EXISTING_PROJECT.md)
- Upgrade a registered project: [`playbooks/UPGRADE_REGISTERED_PROJECT.md`](playbooks/UPGRADE_REGISTERED_PROJECT.md)
- Quality rulebook: [`standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md`](standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md)

Current standard version: `0.5.0`
