# Modular Library Standard

## Principle

Build cross-cutting capabilities behind small, generic, testable boundaries so they can become standalone libraries without forcing every helper into a package immediately.

The goal is **library-ready by default**, not package proliferation.

## What should be designed for reuse

Strong candidates include:

- networking and request execution;
- persistence abstractions and migration support;
- file import and export;
- StoreKit and entitlement handling;
- logging and diagnostics;
- accessibility helpers;
- reusable state and error primitives;
- design tokens and genuinely shared components;
- haptic, audio, notification, and permission adapters;
- testing utilities and deterministic fakes.

Product identity, product-specific workflows, branded copy, proprietary content, and one-off business rules should normally remain in the product repository.

## Library-ready requirements

Reusable code must:

1. Avoid app names, app-specific models, branding, analytics events, assets, and hardcoded product configuration.
2. Accept dependencies and configuration explicitly rather than reading global singletons.
3. Keep public API surface minimal and intentional.
4. Hide implementation details behind internal types.
5. Support deterministic unit tests and failure injection.
6. Define concurrency, thread-safety, cancellation, and lifecycle behavior.
7. Document platform and minimum-version support.
8. Avoid unnecessary third-party dependencies.
9. Include privacy, security, and failure-mode notes where relevant.
10. Use semantic versioning after external consumers depend on it.

## App-local module first

A new capability may begin as an app-local module when its API is still being discovered. It must still be isolated from product-specific UI and data where practical.

Promote it into a standalone library when at least one of these is true:

- a second product needs the capability;
- the capability is clearly infrastructure rather than product logic;
- independent versioning or testing provides meaningful safety;
- maintaining duplicate implementations would create material risk;
- the user explicitly designates it as a shared foundation.

## Package ownership

A mature reusable library should have its own repository, tests, README, changelog, license decision, semantic version, and release process.

The central rules repository records metadata about the library in `registry/libraries.json`; it does not become the implementation repository for all packages.

## Adoption rules

Before writing new cross-cutting infrastructure, inspect `.factory/library-catalog.json` and search the registered reusable libraries.

When a suitable library exists:

- verify its platform and version compatibility;
- use a released version rather than copying source files;
- adapt product models through a thin app-specific adapter;
- contribute generic missing behavior upstream instead of maintaining a permanent fork.

When no suitable library exists:

- implement a narrow app-local module;
- record it in `docs/REUSABLE_COMPONENTS.md`;
- keep extraction boundaries clean;
- create a promotion proposal when the module proves reusable.

## Prohibited shortcuts

Do not:

- copy a whole package into an app to make small changes;
- make a shared library depend on one app's model layer;
- expose internal implementation types unnecessarily;
- add optional behavior through unbounded Boolean parameters;
- publish an untested package merely to call code reusable;
- silently modify a central package from an app task without separate scope and evidence.