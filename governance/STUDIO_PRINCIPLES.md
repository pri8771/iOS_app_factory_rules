# Studio Principles

1. Build real products, not demonstrations that only resemble products.
2. The interface must never claim an operation succeeded before the system confirms it.
3. Sample and mock data may exist in previews and tests, never as an undisclosed production fallback.
4. Prefer local-first architecture unless a backend has a documented product need.
5. Prefer platform-native frameworks and behavior.
6. Accessibility, privacy, error handling, migration, and recovery are part of the feature—not post-launch cleanup.
7. Implement vertically: real data and behavior before broad decorative screen coverage.
8. Preserve user work across failure, navigation, interruption, and relaunch where the product promises persistence.
9. Agents must report what was tested, what was not tested, and why.
10. Completion is derived from evidence, not from an agent’s confidence.
11. Existing projects must be understood before they are reorganized.
12. New projects must define the user outcome, constraints, and Definition of Done before scaling implementation.
13. Keep each product in its own repository unless multiple targets genuinely share one product lifecycle.
14. Design cross-cutting capabilities with generic, testable boundaries and search the reusable-library catalog before reimplementing them.
15. Prefer versioned package reuse over copy-paste reuse.
16. Promote generic improvements upstream with tests, releases, and separate cross-repository evidence; never contaminate shared code with app-specific behavior.
