# GitHub Actions Standard

## Purpose

GitHub Actions is the studio's independent verification and repeatable-execution layer. It does not replace agents or local development. It verifies the exact commit proposed for merge and stores durable evidence beside the pull request.

## Tiered policy

### Tier 0 — Idea or archived repository

No workflow is required. Do not spend runner capacity on inactive work.

### Tier 1 — Repository validation

Use GitHub-hosted Linux runners for inexpensive checks:

- required files and standard locks
- JSON/YAML/schema validation
- secret-pattern scanning
- documentation and generated-file checks
- language compilation or linting that does not require macOS

Run on pull requests and pushes to `main`. Add `paths` filters where a check only applies to specific files.

### Tier 2 — Product build and unit tests

Active iOS products use the studio Mac runner only when source, project, dependency, or test files change. Documentation-only changes must not consume the Mac runner.

Required runner labels:

```yaml
runs-on: [self-hosted, macOS, studio-ios]
```

The workflow must:

1. clean only its own workspace;
2. select and report the Xcode version;
3. generate the project when the repository uses XcodeGen;
4. build for a named simulator destination;
5. run unit tests;
6. upload `.xcresult` and logs even after failure;
7. use concurrency cancellation for superseded pull-request runs.

### Tier 3 — UI journeys

Run XCUITest or Maestro only when UI code, accessibility contracts, fixtures, or journey manifests change, and on manual dispatch before release.

UI tests must use deterministic launch arguments and must not contact production systems, make purchases, send communication, or mutate real customer data.

### Tier 4 — Release

Release workflows run only from an explicit tag or manual dispatch. They may access protected environments and release secrets. Pull-request workflows must never receive production signing or deployment secrets.

## Required controls

- Minimal `permissions`; default to `contents: read`.
- `concurrency` with cancellation for pull-request workflows.
- Timeouts on every job.
- Immutable or major-version-pinned actions from trusted publishers.
- Artifacts retained for failures and verification evidence.
- No secrets in command output or generated files.
- Forked pull requests never run on the self-hosted Mac runner.
- Expensive jobs use path filters or a change-detection job.
- Human approval remains required for production deployment, App Store submission, spending, legal acceptance, and customer-facing sends.

## Evidence contract

A passing status alone is not sufficient for release readiness. Product status should record:

- commit SHA;
- workflow/run URL;
- build destination and Xcode version;
- test counts and result;
- artifact name or evidence path;
- date and verification scope.

## Recommended product layout

```text
.github/workflows/
├── repo-validation.yml
├── ios-ci.yml
├── ui-smoke.yml
└── release-testflight.yml

quality/evidence/
quality/ui/
```

Start from the workflow templates under `templates/github-actions/` and customize only product-specific scheme, workspace/project, simulator, and paths.