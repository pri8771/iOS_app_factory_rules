# Automated UI Testing Standard

## Goal

Give every product broad repeatable UI coverage without requiring bespoke XCTest code for every screen.

## Required layers

1. Fast unit and integration tests for logic.
2. Manifest-generated Maestro flows for broad black-box UI coverage.
3. Targeted XCUITest for critical workflows that need Apple-native assertions, test plans, or complex state control.
4. Human visual review for aesthetics and behavior automation cannot reliably judge.

## Product contract

Every registered UI surface must provide:

- stable accessibility identifiers;
- deterministic test launch arguments;
- resettable fixture data;
- `quality/ui/screens.yaml`;
- `quality/ui/journeys.yaml`;
- prohibited-action declarations;
- build/install commands in the repository map.

## Generated tests

The factory generator should create:

- app launch smoke flow;
- primary navigation flow;
- required-element assertions for every registered screen;
- empty, one-record, many-record, long-text, error, and persistence flows where declared;
- dark-mode and accessibility-text matrices;
- bounded safe exploratory navigation.

## Selector rule

Prefer accessibility identifiers over visible text. Use `<product>.<screen>.<element>.<role>`.

## Safety

Generated exploration must not trigger purchases, destructive actions, external communication, permission prompts, account changes, or irreversible operations unless a specific journey explicitly authorizes and isolates them.

## Verification boundary

Passing generated UI tests means the declared interface contract is healthy. It does not prove all business behavior. Feature contracts and lower-level tests remain required.
