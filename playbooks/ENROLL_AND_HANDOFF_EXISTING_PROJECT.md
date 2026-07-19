# Enroll and Hand Off an Existing Project

## Scope

Use this playbook only when an existing repository is intentionally opting into App Factory governance. Repositories that have not been enrolled remain out of scope.

## Install the CLI

From a checkout of this rules repository:

```bash
python3 -m pip install --user -e .
factory --help
```

## Enroll without strict enforcement

From the product repository:

```bash
factory enroll hindsight --name "Hindsight" --mode existing
```

This creates portable state, task, handoff, policy, and IDE adapter files. The project begins with:

```yaml
factoryStatus: enrolling
enforcementMode: onboarding
```

Existing architecture and historical layout are not rewritten. Review the generated files and commit enrollment separately from feature work.

## Start an execution task

```bash
factory task-start TASK-023 "Add outcome reminders" \
  --risk medium \
  --allow 'Hindsight/Features/Reminders/**' \
  --allow 'HindsightTests/**' \
  --success 'Denied notification permission is handled' \
  --success 'Relevant tests pass'
```

Questions and recommendations do not require a task and remain read-only under the IDE router.

## Switch IDEs

Before leaving the current tool:

```bash
factory checkpoint \
  --source claude-code \
  --target cursor \
  --completed 'Implemented ReminderService and scheduling flow' \
  --remaining 'Handle denied permission and add tests' \
  --failures 'One permission test is failing'
```

In the receiving tool:

```bash
factory resume
```

Then read `AGENTS.md`, `.factory/current-state.yaml`, the active task, and `conversations/handoffs/LATEST.md`. Inspect the current Git diff before editing.

## Promote to managed

After onboarding checks pass:

```bash
factory compliance
factory manage
factory compliance --strict
```

Only after this promotion should strict branch-protection and fleet compliance be enabled.

## Model evidence

For important subagent work, create a run receipt conforming to `schemas/agent-run.schema.json`. Do not label a model or effort provider-verified when only IDE configuration or prompt text requested it.
