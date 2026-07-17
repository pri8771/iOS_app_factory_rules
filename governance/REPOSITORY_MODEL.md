# Repository Model

## Core rule

Use one repository per product and one repository per mature reusable library.

The central `pri8771/iOS_app_factory_rules` repository is a control plane. It stores standards, documentation rules, templates, schemas, project bootstrap tooling, the reusable-library catalog, and promotion workflows. It does not store application source code and should not become a monorepo of unrelated products.

## Repository types

### Product repository

A product repository contains one product and the components that release as that product. An iPhone app, iPad app, macOS app, widget, watch app, web frontend, backend, and shared product packages may live together when they are parts of the same product and share a lifecycle.

Examples:

```text
pri8771/Japa
pri8771/Hindsight
pri8771/Jyot
```

Do not place Japa and Hindsight in the same repository merely because both are made by the App Factory.

### Shared-library repository

A mature reusable capability belongs in its own versioned repository when it has a stable public API, tests, documentation, and at least one demonstrated consumer.

Examples of future library categories include networking, persistence, StoreKit, export, design tokens, logging, accessibility helpers, and test support. The catalog must not claim a library exists until its repository and usable release exist.

### Central rules repository

`pri8771/iOS_app_factory_rules` stores:

- governance and quality standards;
- architecture and documentation rules;
- new and existing project onboarding;
- agent entry-point templates;
- schemas and validation tooling;
- the reusable-library catalog;
- package extraction and contribution playbooks;
- package templates and compatibility policy.

It does not store app-specific PRDs, app code, product secrets, signing assets, or mature shared-library implementation code.

## Local project connection

Each product repository contains a small local registration layer:

```text
.factory/project-context.json
.factory/standard-lock.json
.factory/library-catalog.json
.factory/AGENTS.factory.md
quality/quality-manifest.json
```

The local files make the project self-describing and preserve the exact standards and library-catalog snapshot used when it was registered.

## Cross-repository changes

A product change and a shared-library change must be separate commits or pull requests in their respective repositories. An agent must not silently push app-specific code into a central or shared repository.

When an app discovers a generic missing edge case, the workflow is:

1. reproduce and test the edge case in the product;
2. determine whether the behavior is genuinely generic;
3. add the generic fix and regression test to the shared-library repository;
4. release a new library version;
5. update the central library catalog;
6. update the product dependency and remove temporary duplication.

If the discovery changes a universal engineering rule rather than library behavior, update this central repository through a separate reviewed change.