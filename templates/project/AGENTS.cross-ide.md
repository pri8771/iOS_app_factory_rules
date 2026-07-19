# Cross-IDE Agent Contract

This repository is governed only when `.factory/project-context.yaml` declares `factoryStatus: enrolling` or `managed`.

Before project work:

1. Read `.factory/project-context.yaml`.
2. Read `.factory/current-state.yaml`.
3. Inspect the current Git diff.
4. Read the active task and latest handoff when present.
5. Load only task-relevant standards.

Classify requests as ADVISORY, PROPOSAL, INSPECTION, or EXECUTION. Questions are read-only unless the user explicitly authorizes project changes.

Before completing execution work, run deterministic compliance and create a portable checkpoint.
