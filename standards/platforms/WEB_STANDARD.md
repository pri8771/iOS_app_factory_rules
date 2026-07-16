# Web Platform Standard

Although this repository is iOS-first, the shared quality system is platform-neutral and may govern web apps.

## Required behavior

- Responsive layouts must preserve the primary task at supported viewports and browser zoom.
- Browser back, forward, refresh, and direct deep links must behave intentionally.
- Handle expired sessions, slow APIs, network failures, form resubmission, and multiple tabs.
- Production builds must not bundle development fixtures, private secrets, or debug controls.
- Keyboard navigation, visible focus, semantic landmarks, accessible naming, reduced motion, and automated accessibility scans are required for primary workflows.

## Suggested baseline matrix

- Chromium, WebKit, and Firefox where the product claims support.
- Mobile width near 375–390 points.
- Tablet width near 768 points.
- Desktop widths near 1024, 1280, and 1440 points.
- 200% zoom and long-content scenarios.

## Verification

Use unit tests for state and business rules, integration tests for services and persistence, and browser automation such as Playwright for user journeys and layout scenarios.
