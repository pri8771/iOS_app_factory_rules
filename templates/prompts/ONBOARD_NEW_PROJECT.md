# Prompt: Register a New Project

This is a **new project** governed by `pri8771/iOS_app_factory_rules`.

Before broad implementation:

1. Pull the central rules automatically with `scripts/remote-init.sh` or use a local clone.
2. Add the factory project-registration structure without deleting existing files.
3. Set `.factory/project-context.json` to `projectType: "new"`.
4. Complete the platforms, lifecycle status, constraints, persistence, backend, privacy, and build commands from available evidence.
5. Ensure future agents read the project context, quality manifest, and `.factory/library-catalog.json` first.
6. Search the reusable-library catalog before implementing networking, persistence, StoreKit, export, logging, accessibility helpers, notifications, permissions, or testing infrastructure.
7. Record adopted libraries, rejected candidates, and planned library-ready local modules in `docs/REUSABLE_COMPONENTS.md`.
8. Establish product-specific architecture, features, decisions, risks, assumptions, test plan, and quality manifest.
9. Create feature contracts for the first one to three meaningful user outcomes.
10. Implement one real vertical feature slice before creating broad decorative UI.
11. Prefer released shared libraries plus thin product adapters. When no library fits, build a narrow generic local module with extraction-ready boundaries.
12. Report what was verified, libraries considered, reusable candidates created, and what remains unverified. Do not call the project done based only on scaffolding or compilation.
