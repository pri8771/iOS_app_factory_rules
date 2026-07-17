---
id: GOV-DEFINITION-OF-DONE
canonicalFor: definition-of-done
status: active
lastVerified: 2026-07-17
readWhen:
  - deciding whether a feature or task can be marked done
  - writing a completion report
related:
  - governance/PROJECT_LIFECYCLE.md
  - standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md
supersedes: []
---

# Universal Definition of Done

A feature is done only when all applicable conditions are true.

## Behavior

- The real intended behavior is implemented.
- Success is shown only after confirmed success.
- Failure and cancellation are distinct.
- Duplicate submissions are prevented.
- User input is preserved after recoverable failure.
- No production control is decorative or disconnected from behavior.

## State

- Loading, content, empty, error, disabled, permission, cancellation, and offline states are addressed where applicable.
- Stale asynchronous results cannot overwrite newer state.
- Transient errors do not survive unrelated successful operations.

## Data

- The production data source is identified.
- Persistence is verified after reopening or relaunch when required.
- Delete semantics are explicit.
- Existing data and migrations are considered.
- Sample data cannot masquerade as user data.

## Interface

- The primary task remains completable at supported sizes.
- Long content and accessibility text do not make essential controls unreachable.
- Dark mode and platform conventions are respected where supported.
- Keyboard and assistive-technology access are addressed.

## Verification

- Required automated suites pass.
- At least one relevant non-happy path is tested.
- The completion report names checks that did and did not run.
- Known issues, placeholders, and waivers are disclosed.
- Production configuration is checked before release.
