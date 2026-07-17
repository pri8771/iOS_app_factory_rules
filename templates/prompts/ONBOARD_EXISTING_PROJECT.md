# Prompt: Register an Existing Project

This is an **existing project** being governed by `pri8771/iOS_app_factory_rules`.

Do not replace, re-scaffold, or broadly reorganize the codebase before understanding it.

1. Pull or locate the central rules and run the existing-project bootstrap without overwriting existing files.
2. Set `.factory/project-context.json` to `projectType: "existing"`.
3. Inventory targets, source layout, dependencies, persistence, networking, configuration, tests, CI, known behavior, release status, internal modules, copied helpers, and local packages.
4. Run available baseline checks and record existing failures separately from new failures.
5. Document the current architecture before proposing changes.
6. Review `.factory/library-catalog.json` and compare existing cross-cutting code against registered reusable packages.
7. Record adopted libraries, rejected candidates, duplicates, app-local reusable candidates, and upstream edge cases in `docs/REUSABLE_COMPONENTS.md`.
8. Identify fake data, placeholder behavior, stale errors, resize failures, disconnected settings, data-loss risks, and unverified completion claims.
9. Create feature contracts for the highest-risk active workflows.
10. Make incremental, evidence-backed improvements. Preserve working behavior outside the approved scope.
11. Do not extract a package or replace functioning infrastructure merely to satisfy the standard. Use a separate approved promotion workflow when reuse is evidenced.
12. Report checks run, checks not run, libraries considered, known issues, reusable candidates, and recommended next verification.
