# Prompt: Register an Existing Project

This is an **existing project** being governed by `pri8771/iOS_app_factory_rules`.

Do not replace, re-scaffold, or broadly reorganize the codebase before understanding it.

1. Add the factory project-registration structure without overwriting existing files.
2. Set `.factory/project-context.json` to `projectType: "existing"`.
3. Inventory targets, source layout, dependencies, persistence, networking, configuration, tests, CI, known behavior, and release status.
4. Run available baseline checks and record existing failures separately from new failures.
5. Document the current architecture before proposing changes.
6. Identify fake data, placeholder behavior, stale errors, resize failures, disconnected settings, data-loss risks, and unverified completion claims.
7. Create feature contracts for the highest-risk active workflows.
8. Make incremental, evidence-backed improvements. Preserve working behavior outside the approved scope.
9. Report checks run, checks not run, known issues, and recommended next verification.
