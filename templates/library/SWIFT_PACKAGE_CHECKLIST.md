# Reusable Swift Package Checklist

Use this checklist when promoting an app-local Swift module into a shared package repository.

## Repository

- [ ] Dedicated repository created
- [ ] Clear package name and capability
- [ ] README with installation and examples
- [ ] CHANGELOG
- [ ] License decision recorded
- [ ] Supported Apple platforms and minimum versions declared
- [ ] Ownership and maintenance status declared

## API

- [ ] No product names, branded copy, app assets, or product analytics events
- [ ] Public API is minimal and documented
- [ ] Configuration and dependencies are injected
- [ ] Errors and cancellation behavior are explicit
- [ ] Concurrency and thread-safety expectations are documented
- [ ] Product models are translated by adapters in consuming apps

## Verification

- [ ] Unit tests cover success and failure
- [ ] Regression tests cover extracted behavior
- [ ] Concurrency and cancellation tests exist where applicable
- [ ] Supported platforms build in CI
- [ ] At least one consuming product uses the released package
- [ ] Semantic version released

## Registry

- [ ] `registry/libraries.json` entry added after release
- [ ] Capabilities and platforms are accurate
- [ ] Installation string references a released version
- [ ] Known limitations are disclosed
- [ ] Catalog version incremented
