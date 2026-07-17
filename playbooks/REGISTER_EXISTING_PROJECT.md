# Register an Existing Project

## Register safely

Run locally:

```bash
./scripts/bootstrap-project.sh --target /path/to/repo --mode existing --name "App Name" --platforms ios,macos
```

Or pull the current rules automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target /path/to/repo --mode existing --name "App Name" --platforms ios,macos
```

The bootstrap process does not overwrite existing project documentation or source code.

## Baseline before restructuring

1. Record the current branch and working-tree status.
2. Inventory application targets, source layout, frameworks, dependencies, persistence, networking, configuration, tests, CI, and release history.
3. Inventory existing internal modules, copied helpers, local packages, and third-party dependencies that may overlap with the reusable-library catalog.
4. Run available baseline build and tests and record failures without assuming new changes caused them.
5. Describe current architecture in `docs/ARCHITECTURE.md`.
6. Record known product behavior and incomplete features in `docs/FEATURES.md` and `docs/BUGS.md`.
7. Review `.factory/library-catalog.json` and record adopted, rejected, duplicate, or reusable candidates in `docs/REUSABLE_COMPONENTS.md`.
8. Create an initial quality manifest that reflects actual supported platforms.
9. Create feature contracts first for risky or actively changing workflows.
10. Introduce quality and modularity boundaries incrementally; do not perform an unsolicited rewrite or package extraction.

## Existing reusable code

Do not replace functioning internal infrastructure merely because a central package category exists. Compare behavior, tests, migration risk, and compatibility first.

When app-local code is clearly generic, record it as a promotion candidate. Extract it only through a separate approved change using `playbooks/PROMOTE_CODE_TO_SHARED_LIBRARY.md`.

## Existing-project instruction for an agent

Use `templates/prompts/ONBOARD_EXISTING_PROJECT.md` for the first onboarding pass. After registration, root agent instructions, `.factory/project-context.json`, and `.factory/library-catalog.json` tell future agents how to proceed.
