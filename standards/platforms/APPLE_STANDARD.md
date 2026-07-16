# Apple Platform Standard

Applies to iOS, iPadOS, and macOS projects.

## Shared requirements

- Prefer current Apple frameworks unless an external dependency has a documented benefit.
- Support Dynamic Type and VoiceOver for primary workflows.
- Handle permission denial, app backgrounding, interruption, restoration, and relaunch.
- Test production configuration, not only Debug previews.
- Keep preview and test fixtures out of production targets.

## iOS and iPadOS

- Test a small supported iPhone and a current large iPhone.
- Test iPad full screen and supported multitasking widths.
- Ensure the keyboard does not hide active input or the primary action.
- Preserve expected navigation and back-swipe behavior.
- Use system share, file, photo, and permission flows where appropriate.

## macOS

- Declare a meaningful minimum window size.
- Test compact, standard, expanded, short, split-screen, and full-screen windows.
- Reflow or collapse before clipping essential content.
- Support keyboard navigation and appropriate menu commands.
- Handle window close with unsaved work, restoration, multiple windows, drag and drop, and file opening where applicable.

## Verification

Apple platform verification that requires Xcode must run locally or on a macOS CI runner. An agent operating on Linux must report Apple build and UI checks as unverified rather than claiming completion.
