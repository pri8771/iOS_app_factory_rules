# Cross-IDE Operating Model

## Principle

Agent sessions are disposable. Repository state is durable.

A supported IDE or agent must be able to resume project work from repository contents without access to another tool's private conversation history or memory.

## Enrollment boundary

Factory governance is opt-in for existing projects.

- A repository without `.factory/project-context.yaml` is **unmanaged** and is out of scope for compliance, scheduled audits, documentation mirroring, and fleet reporting.
- `factory enroll <project-id> --mode existing` creates an **enrolling** project. Only onboarding checks apply.
- `factory manage` promotes the repository to **managed** after its enrollment checks pass. Strict compliance then applies.

Enrollment must not rewrite existing architecture or force historical files into a new layout. Legacy conditions may be documented and grandfathered; new changes follow the locked standard after management begins.

## Request routing

Every IDE adapter uses the same four interaction classes:

1. **ADVISORY** — answer or recommend; no writes or mutating commands.
2. **PROPOSAL** — analyze a potential product, scope, dependency, privacy, architecture, or monetization change; do not implement.
3. **INSPECTION** — begin read-only and verify existing behavior.
4. **EXECUTION** — activate a portable task, apply scoped rules, implement, verify, and checkpoint.

Ambiguous requests default to ADVISORY or PROPOSAL. A question is not authorization to modify the repository.

## Portable task state

Execution work is represented under `tasks/`. `.factory/current-state.yaml` identifies the active task and latest durable state. `conversations/handoffs/LATEST.md` records a concise cross-IDE checkpoint.

Typical flow:

```bash
factory task-start TASK-023 "Add outcome reminder scheduling" --risk medium
# Work in Claude, Cursor, Codex, or another supported tool.
factory checkpoint --source claude-code --target cursor \
  --completed "Added ReminderService" \
  --remaining "Handle denied permission and add tests"
# Open the same repository in another IDE.
factory resume
```

The receiving agent must inspect the current Git status and diff, read the active task, and reproduce documented failures before editing.

## Model and effort evidence

`.factory/agent-policy.yaml` defines permitted roles, delegation depth, risk requirements, and minimum evidence.

Agent runs may be recorded under `.factory/runs/` using `schemas/agent-run.schema.json`. Evidence levels are:

- `provider-response` — provider or controlled runner reported the executed model and effort;
- `ide-reported` — the IDE reported runtime configuration;
- `configuration-only` — configuration requested a model but runtime did not verify it;
- `unverified` — no reliable runtime evidence exists.

High-risk work defaults to `provider-response`. Rules or frontmatter alone must never be represented as proof that a specific model or effort ran.

## Enforcement layers

Natural-language rules guide behavior. Deterministic tooling enforces durable requirements.

- IDE router: classification and minimal context loading.
- Factory CLI: enrollment, task state, checkpoint, resume, and structural compliance.
- Git hooks: optional fast changed-file checks.
- GitHub Actions: authoritative merge checks for managed projects.
- Fleet audit: operates only on repositories registered as enrolling or managed.

## Token policy

The always-on router remains small. Full standards are loaded only for EXECUTION and only when relevant. Deterministic checks do not use model tokens. Raw conversation transcripts are not required for handoffs; concise state and evidence are preferred.
