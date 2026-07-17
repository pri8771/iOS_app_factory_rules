# iOS App Factory Rules

Central control plane for AI-assisted iOS, iPadOS, macOS, and web application development.

This repository is the canonical source of truth for studio-wide engineering standards, quality rules, documentation policy, project registration, agent behavior, reusable-library discovery, templates, schemas, and verification requirements.

## Repository model

Use:

- one repository per product;
- one repository per mature reusable library;
- this repository as the central rules, registry, and automation control plane.

Application source code does not live here. Japa, Hindsight, Jyot, and other products remain separate repositories. Shared package implementations also receive dedicated repositories once they are mature enough to release independently.

See [`governance/REPOSITORY_MODEL.md`](governance/REPOSITORY_MODEL.md).

## How an agent recognizes a project

A registered product repository contains:

```text
.factory/project-context.json
.factory/standard-lock.json
.factory/library-catalog.json
.factory/AGENTS.factory.md
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

All entry files point to the same machine-readable project context, quality manifest, and reusable-library catalog.

## Automatically initialize a project

From inside a product repository:

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target "$PWD" --mode new --name "My App" --platforms ios,ipados
```

For an existing repository, use `--mode existing`.

The remote initializer clones a fresh temporary copy of this repository, runs the bootstrap, installs local agent and quality files, copies a snapshot of the reusable-library catalog, and verifies registration. It does not move the app into this repository.

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

## Start here

- Repository model: [`governance/REPOSITORY_MODEL.md`](governance/REPOSITORY_MODEL.md)
- New product repository: [`playbooks/CREATE_NEW_PRODUCT_REPOSITORY.md`](playbooks/CREATE_NEW_PRODUCT_REPOSITORY.md)
- Existing project onboarding: [`playbooks/REGISTER_EXISTING_PROJECT.md`](playbooks/REGISTER_EXISTING_PROJECT.md)
- Agent detection: [`playbooks/AGENT_PROJECT_DETECTION.md`](playbooks/AGENT_PROJECT_DETECTION.md)
- Quality rulebook: [`standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md`](standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md)

Current standard version: `0.3.0`
