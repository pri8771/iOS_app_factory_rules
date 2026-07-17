# LLM Start Here

Use this file as the shortest reliable entry point into the App Factory control plane.

## Repository identity

- Type: central control plane
- Repository: `pri8771/iOS_app_factory_rules`
- Contains: governance, standards, schemas, templates, automation, reusable-library registry
- Does not contain: product source code or mature shared-library source code

## Read in this order

1. `AGENTS.md`
2. `governance/REPOSITORY_MODEL.md`
3. `governance/DOCUMENTATION_POLICY.md`
4. `governance/DEFINITION_OF_DONE.md`
5. `standards/documentation/LLM_DOCUMENTATION_STANDARD.md`
6. Only the standard, schema, template, or playbook relevant to the current task

Do not recursively read the entire repository by default.

## Fast task routing

| Task | Read next |
|---|---|
| Register a new product | `playbooks/START_NEW_PROJECT.md` |
| Register an existing product | `playbooks/REGISTER_EXISTING_PROJECT.md` |
| Build reusable infrastructure | `standards/engineering/MODULAR_LIBRARY_STANDARD.md` and `standards/engineering/REUSE_FIRST_WORKFLOW.md` |
| Promote code to a package | `playbooks/PROMOTE_CODE_TO_SHARED_LIBRARY.md` |
| Check product quality | `standards/quality/VIBE_CODING_QUALITY_RULEBOOK.md` |
| Understand repository ownership | `governance/REPOSITORY_MODEL.md` |
| Understand documentation authority | `governance/DOCUMENTATION_POLICY.md` |
| Search reusable packages | `registry/libraries.json` |
| Modify bootstrap behavior | `scripts/bootstrap-project.sh`, schemas, templates, and bootstrap tests |

## LLM navigation rules

- Prefer indexes and machine-readable maps before deep reading.
- Read canonical documents, not every related document.
- Follow `supersedes`, `canonicalFor`, `related`, and `readWhen` metadata where present.
- Do not treat examples or templates as implemented product facts.
- Do not create a new document when an existing canonical document owns the topic.
- Summarize large documents before loading additional files.
- Retrieve only the sections needed for the current task.

## Product repository entry path

A registered product should be read in this order:

```text
AGENTS.md
→ .factory/repository-map.json
→ .factory/project-context.json
→ .factory/standard-lock.json
→ .factory/library-catalog.json
→ docs/README.md
→ task-relevant canonical documents and feature contracts
```

The repository map is the navigation authority. The project context is the project-classification authority. Feature contracts define required feature behavior. Code remains authoritative for current implemented behavior.
