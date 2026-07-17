# Promote Code to a Shared Library

Use this playbook when an app-local module has proven reusable or when an existing shared package needs a generic edge-case improvement.

## Promotion gate

Before extraction, document:

- the capability and user-independent problem it solves;
- current product consumers;
- evidence that the behavior is not app-specific;
- proposed public API;
- supported platforms and minimum versions;
- dependency and licensing implications;
- migration plan for the originating app;
- ownership and maintenance expectations.

A second real consumer is strong evidence, but foundational infrastructure may be promoted earlier when the generic boundary is already clear.

## Extraction steps

1. Freeze existing behavior with tests in the product repository.
2. Remove app names, branding, product models, analytics events, assets, and hardcoded configuration.
3. Define generic input, output, error, configuration, and lifecycle contracts.
4. Create a dedicated repository for the library.
5. Add independent unit tests, failure tests, concurrency tests, and platform tests as applicable.
6. Add README, installation instructions, API examples, changelog, support policy, and license decision.
7. Publish an initial semantic version.
8. Add the released library to `registry/libraries.json` in the central rules repository.
9. Replace the app-local implementation with the released dependency plus a thin product adapter.
10. Verify the original app behavior and another consumer when available.

## Generic edge-case contribution

When an app uncovers a generic defect in an existing library:

1. Reproduce it in the app and protect user behavior.
2. Add the smallest generic failing test in the library repository.
3. Implement the fix without importing app-specific concepts.
4. Run the library's complete test suite.
5. Release a patch or minor version according to semantic-versioning impact.
6. Update catalog metadata when the stable version, limitations, or capabilities change.
7. Upgrade the app and remove any temporary workaround.

## Cross-repository safety

- Use separate branches, commits, and pull requests for the product, library, and central registry.
- Do not push directly to another repository merely because the agent has permission.
- Do not claim the product fix is complete until the released library is consumed and verified.
- Do not register a library in the catalog before a usable repository and release exist.
- Do not broaden a package API for hypothetical future use without a concrete requirement.