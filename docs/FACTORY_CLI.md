# Factory CLI

Install from the rules repository:

```bash
python3 -m pip install --user -e .
```

Commands:

```text
factory enroll PROJECT_ID [--name NAME] [--mode existing|new]
factory manage
factory task-start TASK_ID TITLE [--risk low|medium|high]
factory checkpoint [--source TOOL] [--target TOOL]
factory resume
factory compliance [--strict]
```

`factory compliance` intentionally returns success for repositories that have not been enrolled. Existing projects enter onboarding mode first and are promoted to strict managed status only through `factory manage` after checks pass.
