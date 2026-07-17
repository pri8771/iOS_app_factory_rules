---
id: DOC-INDEX
canonicalFor: documentation-navigation
status: active
lastVerified: REPLACE_DATE
readWhen:
  - onboarding
  - locating authoritative project information
related:
  - .factory/repository-map.json
supersedes: []
---

# Documentation Index

## Purpose

Use this index to find the smallest authoritative set of documents for the current task. Do not read every document by default.

## Two-minute project context

Read in order:

1. `../AGENTS.md`
2. `../.factory/repository-map.json`
3. `../.factory/project-context.json`
4. `STATUS.md`
5. `ARCHITECTURE.md`
6. Only the task-relevant documents below

## Canonical documents

| Topic | Canonical document | Authority |
|---|---|---|
| Project identity and type | `../.factory/project-context.json` | Machine-readable project classification |
| Standards and catalog versions | `../.factory/standard-lock.json` | Installed central versions |
| Repository navigation | `../.factory/repository-map.json` | Reading and location map |
| Current status | `STATUS.md` | Current progress, blockers, verification |
| Current architecture | `ARCHITECTURE.md` | Implemented architecture, not proposals |
| Feature inventory | `FEATURES.md` | Current feature status |
| Required feature behavior | `../quality/feature-contracts/` | Acceptance and state contracts |
| Current bugs | `BUGS.md` | Known defects and unverified behavior |
| Decisions | `DECISIONS.md` | Approved product and architecture decisions |
| Risks | `RISKS.md` | Active risks and mitigations |
| Assumptions | `ASSUMPTIONS.md` | Unconfirmed facts |
| Testing | `TEST_PLAN.md` | Commands, environments, and required scenarios |
| Release readiness | `RELEASE_CHECKLIST.md` | Release gates |
| Reusable code | `REUSABLE_COMPONENTS.md` | Packages, local candidates, upstream work |
| Handoff | `HANDOFF.md` | Next-agent context |

## Task-based reading routes

### Implement or change a feature

Read:

1. `STATUS.md`
2. `ARCHITECTURE.md`
3. the relevant feature contract;
4. `DECISIONS.md` when the change crosses a locked decision;
5. `TEST_PLAN.md` for applicable verification.

### Fix a bug

Read:

1. `BUGS.md`
2. the relevant feature contract;
3. `ARCHITECTURE.md`;
4. `TEST_PLAN.md`.

### Add infrastructure or a dependency

Read:

1. `../.factory/library-catalog.json`
2. `REUSABLE_COMPONENTS.md`
3. `ARCHITECTURE.md`
4. `DECISIONS.md`
5. the applicable central dependency and modular-library standards.

### Prepare a release

Read:

1. `STATUS.md`
2. `TEST_PLAN.md`
3. `RELEASE_CHECKLIST.md`
4. current bugs, risks, and waivers.

## Historical and superseded documents

List old or superseded documents here. Do not leave their authority ambiguous.

| Document | Status | Superseded by | Reason retained |
|---|---|---|---|

## Documentation gaps

List missing, stale, contradictory, or unverified documentation here rather than silently guessing.
