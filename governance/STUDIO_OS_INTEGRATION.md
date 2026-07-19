# Studio OS Integration

## Purpose

Connect product engineering governance in this repository with portfolio and operational governance in `pri8771/studio-ios` without duplicating either control plane.

## Authority

- Studio OS owns portfolio priority, shared operations, external-action approvals, cross-product dashboards, marketing/CRM coordination, and domain-standard registration.
- iOS App Factory owns Apple-platform product engineering, product repository bootstrap, quality, documentation, testing, reusable infrastructure, build, and release requirements.
- Product repositories own product code, requirements, current architecture, tests, evidence, and product-specific decisions.

Lower layers may be stricter but may not weaken higher-level security, approval, evidence, privacy, or quality requirements.

## Product registration

A registered product should pin:

1. Studio OS standard and product manifest;
2. iOS App Factory standard version and commit;
3. product repository and project type;
4. product-specific approved overrides.

The local `.factory/standard-lock.json` remains the product repository's lock file. Future schema revisions should allow multiple named standards while preserving compatibility with existing 0.4.0 registrations.

## Agent retrieval

Agents working on product implementation remain inside the product/App Factory context unless the task concerns portfolio priority, shared services, external publishing, cost, or cross-product operations.

## Change propagation

Central changes create explicit upgrade proposals. They do not silently rewrite product repositories. Product adoption must be recorded in the standard lock and verified by bootstrap/validation tooling.
