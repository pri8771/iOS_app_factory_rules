# iOS App Factory Rules

Central operating system for AI-assisted iOS, iPadOS, macOS, and web application development.

This repository is the canonical source of truth for:

- studio-wide engineering and quality standards;
- agent behavior and completion reporting;
- project lifecycle and Definition of Done;
- reusable project-registration templates;
- feature contracts, quality manifests, and completion reports;
- onboarding playbooks for new and existing projects.

## How projects are recognized

A project is registered with the factory when its repository contains:

```text
.factory/project-context.json
.factory/standard-lock.json
quality/quality-manifest.json
AGENTS.md
```

`project-context.json` declares whether the repository is a new project or an existing project being onboarded. Agents must read that file before making changes.

## Start here

1. Read [`AGENTS.md`](AGENTS.md).
2. Read [`governance/STUDIO_PRINCIPLES.md`](governance/STUDIO_PRINCIPLES.md).
3. For a new app, follow [`playbooks/START_NEW_PROJECT.md`](playbooks/START_NEW_PROJECT.md).
4. For an existing app, follow [`playbooks/REGISTER_EXISTING_PROJECT.md`](playbooks/REGISTER_EXISTING_PROJECT.md).
5. Use `scripts/bootstrap-project.sh` to install the project-local structure.

## Repository model

This repository contains universal standards. Each application repository contains only its own product documentation, feature contracts, evidence, and a lock to a released version of these standards.

```text
iOS_app_factory_rules
        ├── App repository A
        ├── App repository B
        └── Web repository C
```

Do not maintain independent copies of the central standards inside every app. Project repositories should contain a small local registration and quality layer that points back here.

## Current standard version

`0.1.0`
