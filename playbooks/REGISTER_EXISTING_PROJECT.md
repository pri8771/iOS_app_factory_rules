# Register an Existing Project

## Register safely

Run:

```bash
./scripts/bootstrap-project.sh --target /path/to/repo --mode existing --name "App Name" --platforms ios,macos
```

The bootstrap script does not overwrite existing project documentation.

## Baseline before restructuring

1. Record the current branch and working-tree status.
2. Inventory application targets, source layout, frameworks, dependencies, persistence, networking, configuration, tests, CI, and release history.
3. Run available baseline build and tests and record failures without assuming new changes caused them.
4. Describe current architecture in `docs/ARCHITECTURE.md`.
5. Record known product behavior and incomplete features in `docs/FEATURES.md` and `docs/BUGS.md`.
6. Create an initial quality manifest that reflects actual supported platforms.
7. Create feature contracts first for risky or actively changing workflows.
8. Introduce quality boundaries incrementally; do not perform an unsolicited rewrite.

## Existing-project instruction for an agent

Use `templates/prompts/ONBOARD_EXISTING_PROJECT.md` for the first onboarding pass. After registration, root `AGENTS.md` and `.factory/project-context.json` tell future agents how to proceed.
