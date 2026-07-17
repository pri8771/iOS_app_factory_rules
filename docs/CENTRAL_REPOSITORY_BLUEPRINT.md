# Central Repository Blueprint

`pri8771/iOS_app_factory_rules` is the App Factory control plane.

## Responsibilities

### Governance

- studio principles;
- repository ownership model;
- project and work-item lifecycle;
- Definition of Ready and Done;
- documentation authority;
- exceptions and waivers;
- cross-repository change policy.

### Engineering and quality standards

- architecture and state management;
- modular library design;
- reuse-first development;
- persistence and migration;
- networking and external services;
- privacy and security;
- accessibility and responsive layout;
- error handling, observability, performance, and testing;
- AI feature and coding-agent requirements;
- release readiness.

### Documentation system

- required documents per product stage;
- product, technical, design, QA, business, legal, release, and handoff templates;
- schemas for machine-readable contracts and reports;
- rules for updating documentation with behavior changes;
- central-versus-product-versus-library ownership.

### Project automation

- automatic remote initialization;
- non-destructive existing-project onboarding;
- local project-context and standards locks;
- IDE and agent instruction adapters;
- quality manifests, feature contracts, completion reports, waivers, and evidence folders;
- project-registration verification and CI.

### Reusable library system

- trusted catalog of released packages;
- capability and compatibility metadata;
- package creation templates;
- extraction and promotion playbooks;
- semantic-version and migration policy;
- upstream generic edge-case workflow;
- local snapshots for product agents.

### Portfolio support

The central repository may contain universal product, design, business, legal, security, and release frameworks. Product-specific plans, branding, metrics, budgets, credentials, and release artifacts remain in the product repository or approved operational system.

## Repository topology

```text
pri8771/iOS_app_factory_rules       central control plane
pri8771/Japa                        product repository
pri8771/Hindsight                   product repository
pri8771/Jyot                        product repository
pri8771/<SharedLibrary>             versioned shared package repository
```

A product may contain multiple platform targets when they are one product. Unrelated products remain separate.

## New-project lifecycle

```text
create product repository
→ run remote initializer
→ commit local factory files
→ read project context and library catalog
→ define product scope and contracts
→ adopt or create library-ready infrastructure
→ implement vertical slice
→ verify
```

## Existing-project lifecycle

```text
open existing product repository
→ run existing-mode initializer
→ inventory current behavior and reusable modules
→ establish build and test baseline
→ compare infrastructure with library catalog
→ document gaps and candidates
→ improve incrementally
```

## Library lifecycle

```text
app-local generic module
→ evidence of reuse
→ API and dependency review
→ dedicated library repository
→ tests and documentation
→ semantic release
→ central catalog registration
→ versioned product adoption
→ generic fixes promoted upstream
```

## Non-goals

The central repository must not become:

- a monorepo of unrelated apps;
- a source dump of copied helpers;
- a substitute for product documentation;
- a place for unreleased placeholder libraries;
- an automatic cross-repository mutation service without review;
- a storage location for secrets or signing assets.
