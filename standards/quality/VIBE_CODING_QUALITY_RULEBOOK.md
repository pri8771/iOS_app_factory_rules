# Vibe Coding Quality Rulebook

## Purpose

AI-assisted development often produces software that looks more complete than it is. This standard prevents false completeness.

A screen is not a feature. A feature is complete only when its real behavior, states, data, recovery, accessibility, and verification are complete.

## Non-negotiable rules

1. Never implement only the happy path.
2. Never show success before success is confirmed.
3. Never use fake data as an undisclosed production fallback.
4. Every data-driven screen needs explicit state modeling.
5. Resizing must cause useful reflow, collapse, or scrolling—not inaccessible clipping.
6. Cancellation is not an error.
7. Repeated taps must not duplicate consequential operations.
8. A failed operation must not erase recoverable user work.
9. Existing persisted data must survive model changes or have an explicit migration plan.
10. Agents must disclose unverified behavior.

## Screen states

Address the applicable states explicitly:

- idle or initial;
- loading;
- content;
- empty;
- refreshing or stale content;
- partial content;
- error;
- offline;
- permission denied or restricted;
- disabled;
- cancellation.

Avoid unrelated Boolean flags that permit contradictory combinations. Prefer one explicit state machine or discriminated union.

## Layout and resizing

- Avoid fixed screen-level geometry intended only to match a screenshot.
- Define minimum usable macOS window dimensions without using them as a substitute for adaptive layout.
- Test compact, standard, expanded, short, split-screen, and full-screen layouts as applicable.
- Test the smallest supported phone, tablet multitasking, long content, and maximum accessibility text.
- Essential actions, errors, warnings, prices, dates, and destructive consequences must remain reachable.
- When space becomes limited, reflow first, collapse secondary content second, scroll when needed, and truncate only low-priority content.

## Error handling

- Errors belong to the operation that caused them.
- Clear stale errors when a new operation begins.
- Do not show errors before the first attempt completes.
- Treat empty results, cancellation, and permission denial as their own states.
- Map technical failures to safe, specific user messages.
- Never expose stack traces, tokens, database errors, model prompts, raw exception text, or private file paths.
- Preserve form input and allow retry where recovery is possible.

## Data integrity

- In-memory state is not persistence.
- Verify save, close, reopen, fetch, delete, reopen.
- Define whether deletion means local removal, trash, server deletion, relationship removal, or account-wide deletion.
- Multi-step writes must be atomic, incremental, or recoverable by design.
- Dates, time zones, decimal precision, currency, rounding, and locale must be explicit.
- Migrations must be tested against old-version fixture data.

## Fake-feature prohibition

The following are incomplete unless clearly development-only:

- controls with empty actions;
- toggles that change appearance but no behavior;
- settings never read by the app;
- searches over hardcoded demo data;
- temporary deletes that return after relaunch;
- success screens that always appear;
- charts with placeholder values;
- exports that have not been opened and validated;
- login forms that accept arbitrary credentials;
- AI results returned from static fixtures.

Remove incomplete controls, label them honestly, disable them with an explanation, or protect them behind a development flag.

## Asynchronous behavior

- Every operation terminates in success, failure, or cancellation.
- Use operation identity or cancellation so older requests cannot overwrite newer state.
- Retry must be idempotent for consequential operations.
- Offline behavior must be declared before the user invests in a long workflow.

## Forms

- Do not mark untouched forms invalid on first appearance unless intentionally required.
- Validate whitespace, length, ranges, duplicates, formats, file types, file sizes, and conflicting selections.
- Prevent submission when required input is invalid.
- The keyboard must not cover the active field or primary action.

## Navigation

- Every destination must be reachable and escapable.
- Prevent duplicate pushes and stacked identical sheets.
- Preserve useful context such as filters, search, selection, and scroll position.
- Missing or malformed deep links must fail safely rather than opening unrelated content.

## Permissions and privacy

- Request permissions in context.
- Permission denial is a normal product state.
- Collect and log only what is necessary.
- Never ship secrets in client code.
- Do not place private user content, credentials, full documents, precise location, or sensitive AI prompts in analytics or ordinary logs.

## Accessibility

- Interactive controls need meaningful names, roles, values, and focus order.
- Support large text, keyboard navigation, reduced motion, adequate contrast, and non-color status indicators.
- Icon-only controls require accessible labels.
- Test the primary workflow with assistive technologies appropriate to the platform.

## AI features

- Distinguish generated suggestions from verified facts.
- Validate structured model output before use.
- Test empty, long, malformed, scanned, contradictory, adversarial, and unsupported inputs.
- Treat model refusal, timeout, cancellation, invalid output, and partial processing as explicit states.
- Do not let generated output directly perform destructive or externally visible actions without review or explicit confirmation.

## Performance

Test realistic data volume, large files, repeated navigation, background/foreground cycles, poor connectivity, and constrained resources. Heavy work must not block the main interface thread.

## Release hygiene

Remove or verify debug menus, test accounts, staging endpoints, sample records, placeholder content, mock purchases, excessive logging, experimental flags, unused permissions, incorrect legal links, and temporary assets.

## Required edge-case set

For each meaningful feature, test the applicable subset of:

1. no data;
2. one record;
3. many records;
4. long text;
5. invalid and duplicate input;
6. interrupted operation;
7. repeated rapid action;
8. permission denial;
9. offline or slow operation;
10. failure and retry;
11. relaunch or refresh;
12. old-version data;
13. smallest layout;
14. largest text;
15. dark mode;
16. keyboard or screen-reader use.

## Final standard

A user must be able to understand the true state, complete the task, recover when something fails, and trust what the app says happened. If that is not established, the feature is not done.
