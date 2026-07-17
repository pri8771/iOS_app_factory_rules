# Start a New Project

## Register automatically

From inside the new product repository:

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target "$PWD" --mode new --name "App Name" --platforms ios,ipados
```

This fetches a fresh temporary copy of the central rules, installs the local standards and library-catalog snapshot, and verifies registration. The product remains in its own repository.

A local clone may also run:

```bash
./scripts/bootstrap-project.sh --target /path/to/repo --mode new --name "App Name" --platforms ios,ipados
```

## Before broad coding

1. Complete `.factory/project-context.json`.
2. Complete `quality/quality-manifest.json`.
3. Review `.factory/library-catalog.json` for reusable infrastructure relevant to the product.
4. Record adopted libraries, rejected candidates, and planned local modules in `docs/REUSABLE_COMPONENTS.md`.
5. Write the product brief and MVP boundary in `docs/FEATURES.md`.
6. Record architecture and persistence decisions in `docs/ARCHITECTURE.md` and `docs/DECISIONS.md`.
7. Create contracts for the first one to three user outcomes.
8. Establish build, test, formatting, and CI commands.
9. Implement one vertical feature slice using real behavior.
10. Verify at least one success and one failure path.

## Reusable infrastructure

When the catalog contains a suitable package, use a released version plus a thin product adapter. When no package fits, create a narrow library-ready local module instead of embedding cross-cutting behavior directly in views or feature code.

Do not create a new standalone package for every small helper. Promote code after its generic boundary is evidenced.

## New-project instruction for an agent

Use `templates/prompts/ONBOARD_NEW_PROJECT.md` as the reusable instruction. Once registered, the local repository files become authoritative and the prompt does not need to be repeated every session.
