# Start a New Project

## Register

Run:

```bash
./scripts/bootstrap-project.sh --target /path/to/repo --mode new --name "App Name" --platforms ios,ipados
```

## Before broad coding

1. Complete `.factory/project-context.json`.
2. Complete `quality/quality-manifest.json`.
3. Write the product brief and MVP boundary in `docs/FEATURES.md`.
4. Record architecture and persistence decisions in `docs/ARCHITECTURE.md` and `docs/DECISIONS.md`.
5. Create contracts for the first one to three user outcomes.
6. Establish build, test, formatting, and CI commands.
7. Implement one vertical feature slice using real behavior.
8. Verify at least one success and one failure path.

## New-project instruction for an agent

Use `templates/prompts/ONBOARD_NEW_PROJECT.md` as the reusable instruction. Once registered, the repository files become authoritative and the prompt does not need to be repeated every session.
