# Create a New Product Repository

Use one repository per product. Keep unrelated products separate even when they share central standards and libraries.

## Automatic initialization

From inside a newly created or cloned product repository, run:

```bash
curl -fsSL https://raw.githubusercontent.com/pri8771/iOS_app_factory_rules/main/scripts/remote-init.sh | \
  bash -s -- --target "$PWD" --mode new --name "Product Name" --platforms ios,ipados
```

The remote initializer downloads a fresh temporary copy of the central rules repository and runs the versioned bootstrap. The application is not moved into the rules repository.

For an existing repository, change `--mode new` to `--mode existing`.

## Before implementation

1. Verify the generated registration with `.factory/project-context.json` and `quality/quality-manifest.json`.
2. Read the local agent instructions and central-standard lock.
3. Review `.factory/library-catalog.json` before implementing networking, persistence, StoreKit, export, logging, accessibility helpers, or other cross-cutting infrastructure.
4. Define product scope, architecture, first feature contracts, and test commands.
5. Implement one vertical feature slice with real data and behavior.
6. Record app-local modules that may be reusable in `docs/REUSABLE_COMPONENTS.md`.

## Repository boundary

The product repository owns:

- product code and product-specific packages;
- PRDs, architecture, decisions, risks, tests, and evidence;
- product CI, release history, secrets, and deployment configuration;
- thin adapters around shared libraries.

The central rules repository owns standards, templates, schemas, bootstrap tooling, and the library catalog. Shared library implementations belong in dedicated library repositories.