# Project Lifecycle

## Product lifecycle

```text
idea
→ research
→ validated
→ planned
→ prototype
→ mvp_development
→ code_complete
→ verification_pending
→ verified
→ beta
→ release_candidate
→ released
→ maintained
→ paused_or_retired
```

## Work-item lifecycle

```text
planned
→ ready
→ in_progress
→ code_complete
→ verification_pending
→ verified
→ human_review_required
→ done
```

## Rules

- `code_complete` means the intended implementation exists, not that all supported environments were tested.
- `verification_pending` is required whenever a mandatory check could not run.
- `verified` requires the automated checks declared by the quality manifest.
- `human_review_required` identifies subjective or hardware-dependent review that automation cannot establish.
- `done` requires all applicable automated and human gates or an approved waiver.
- `blocked` may be applied at any stage, with the blocker and next action documented.
