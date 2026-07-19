# Factory Project State

This directory contains portable, tool-neutral project state. IDE-specific memory is never the sole source of resumability.

- `project-context.yaml`: enrollment and project identity.
- `current-state.yaml`: active task and latest durable state.
- `scope-lock.yaml`: release scope and approval triggers.
- `agent-policy.yaml`: subagent roles and model-verification requirements.
- `standard-lock.json`: locked central-rules version.
- `runs/`: auditable agent run receipts.
