# Changelog

All notable changes to the App Factory Rules are recorded here.

## 0.2.0 — 2026-07-16

### Added

- Tool-specific project entry templates for Claude Code, Gemini, Cursor, and GitHub Copilot.
- Central IDE and agent setup guide.
- Machine-readable `agentEntryPoints` in the project context.
- Product, design, business, legal, shared-design, and release-standard indexes.

### Changed

- The project bootstrap now installs cross-agent entry files without silently replacing existing instructions.
- Project registration verification and local standards remain centralized through `.factory/project-context.json` and `.factory/AGENTS.factory.md`.

## 0.1.0 — 2026-07-16

### Added

- Central repository structure.
- New-versus-existing project registration protocol.
- Project context, standard lock, quality manifest, feature contract, and completion report schemas.
- Initial quality, architecture, platform, and AI-agent standards.
- Safe project bootstrap and registration verification scripts.
- Templates for project documentation and quality evidence.
