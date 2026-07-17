# LLM-First Documentation Standard

## Goal

Organize repositories so a coding agent can identify the project, locate authoritative facts, retrieve only task-relevant context, and avoid contradictory documentation within minutes.

Human readability remains required. LLM efficiency must not produce cryptic or incomplete documents.

## Information architecture

Every registered product repository must provide this fast path:

```text
AGENTS.md
→ .factory/repository-map.json
→ .factory/project-context.json
→ docs/README.md
→ task-relevant canonical documents
```

Do not require an agent to scan the entire repository to determine what it is, whether it is new or existing, how it builds, or which documents are authoritative.

## One topic, one canonical owner

Each durable topic must have one canonical document or machine-readable file.

Examples:

- project identity and type: `.factory/project-context.json`;
- standards and catalog versions: `.factory/standard-lock.json`;
- repository navigation: `.factory/repository-map.json`;
- current status: `docs/STATUS.md`;
- implemented architecture: `docs/ARCHITECTURE.md`;
- required feature behavior: `quality/feature-contracts/`;
- current bugs: `docs/BUGS.md`;
- decisions: `docs/DECISIONS.md`;
- reusable-code decisions: `docs/REUSABLE_COMPONENTS.md`.

Related documents should link to the canonical owner instead of repeating its full content.

## Document metadata

Durable Markdown documents should begin with a compact metadata block when practical:

```yaml
---
id: DOC-ARCHITECTURE
canonicalFor: current-architecture
status: active
lastVerified: 2026-07-17
owners: [engineering]
readWhen:
  - changing architecture
  - onboarding an agent
related:
  - docs/DECISIONS.md
  - docs/TEST_PLAN.md
supersedes: []
---
```

Use stable IDs. Do not rename IDs when titles change.

Metadata must not contain invented verification dates or owners.

## Required opening structure

Long documents should start with:

1. purpose;
2. authority and scope;
3. current summary;
4. read-next links;
5. detailed sections.

Put current truth before history. Put implementation details after the summary.

## Bounded documents

Prefer several focused canonical documents over one enormous document covering unrelated domains.

A focused document should normally answer one durable question, such as:

- What does the product do?
- What architecture currently exists?
- What is the current release status?
- What decisions are locked?
- What needs verification?

Do not split a single coherent topic into dozens of tiny files that require excessive traversal.

## Stable headings

Use descriptive, stable headings. Avoid headings such as `Misc`, `Other`, `Notes`, or `More`.

Agents and retrieval systems should be able to target sections by predictable names such as:

- `## Current State`
- `## Architecture`
- `## Data Flow`
- `## Build and Test`
- `## Known Limitations`
- `## Decisions`
- `## Verification Status`

## Explicit status vocabulary

Use controlled terms where status matters:

```text
planned
in_progress
implemented
partially_implemented
placeholder
mocked
broken
unverified
verification_pending
verified
deprecated
retired
```

Do not alternate among vague synonyms such as nearly done, mostly complete, basically finished, or should work.

## Facts, decisions, assumptions, and proposals

Never mix these without labels.

- **Fact:** directly supported by code, test output, configuration, or authoritative records.
- **Decision:** intentionally selected and recorded.
- **Assumption:** not yet confirmed.
- **Proposal:** suggested future change, not approved current behavior.

Put proposals in a clearly named section such as `Potential Improvements — Not Approved`.

## Retrieval efficiency

- Put concise summaries at the top.
- Use tables for inventories and status matrices.
- Use lists for discrete rules and steps.
- Keep paragraphs focused.
- Link exact repository paths.
- Avoid decorative prose in operational documents.
- Avoid duplicating large content blocks.
- Archive obsolete documents or mark them superseded.
- Keep history in changelogs and decision records rather than the current-state summary.

## Machine-readable maps

`.factory/repository-map.json` must identify:

- repository type;
- primary entry files;
- canonical documents by topic;
- build and test configuration locations;
- source and test roots;
- quality and feature-contract locations;
- reusable-library catalog and tracking files;
- files an agent should not treat as current truth;
- task-based reading routes.

The map is navigation metadata. It does not replace the documents or source code.

## Documentation index

`docs/README.md` must provide:

- the canonical reading order;
- a topic-to-document table;
- current versus historical documents;
- document ownership and authority;
- task-specific reading routes;
- known documentation gaps.

## Change discipline

When behavior changes:

1. update code;
2. update the relevant feature contract;
3. update the one canonical document that owns the affected topic;
4. update test and verification evidence;
5. avoid editing unrelated summary documents unless their current truth changed.

## Anti-patterns

Do not:

- create multiple competing PRDs;
- copy the same status summary into many files;
- use filenames such as `FINAL_FINAL_V2.md`;
- preserve obsolete documents without a superseded marker;
- force agents to infer authority from modification dates;
- mix current architecture with unapproved future architecture;
- store essential facts only in chat transcripts;
- make every agent reread every standard for every task;
- use huge unstructured memory dumps as the primary project documentation.
