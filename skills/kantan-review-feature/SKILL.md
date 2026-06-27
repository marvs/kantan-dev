---
name: kantan-review-feature
description: Use when implementation is complete and before finishing a feature in a Rails + React app. Performs an expert Rails + React code review of the changes against the plan, the repo conventions, and universal best practices.
---

# Review a Feature

Act as an expert Rails + React reviewer. Review the implemented changes against the approved plan before the feature is finished. This step makes no commits and ships no code — it produces findings.

## Gather context

1. Read the plan at `<backend-root>/.kantan-dev/plans/YYYYMMDD_feature_name.md` (and the idea, for intent).
2. Read each involved repo's conventions file — `AGENTS.md` if present, else `CLAUDE.md` — for the backend and the target frontend.
3. Collect the full change set in each involved repo from the **working tree** (changes are not committed): run `git status` and `git diff`, and include untracked/new files. Review everything that changed.

## Review against the plan first

- Every task / acceptance criterion in the plan is implemented — nothing missing.
- Nothing beyond the plan's scope crept in (flag scope drift).
- The plan's stated verification steps actually pass.

## Review for quality

Check the changes against the repo's conventions **and** these universals — **repo conventions win**:

**Backend (Rails)**
- Specs exist and are meaningful for new models/services/jobs/endpoints; external HTTP stubbed; suite green.
- Fat service / thin controller; jobs delegate to services.
- N+1s: missing eager-loads / `with_attached_*`, missing `.distinct` on `has_many :through` filters, per-row queries in loops/serializers.
- Security: authn/authz on new endpoints, strong params, no plaintext secrets/PII, no mass-assignment holes.
- DB: NOT NULL / foreign-key constraints + indexes on foreign keys; reversible migrations.
- Collection endpoints paginate. Linter clean.

**Frontend (React)**
- Matches the repo's stack and style (state lib, styling, quotes/width) — not imposed from memory.
- Stable list keys (no bare index); effect dependencies correct; no stale closures; cleanup where needed.
- HTTP via the repo's wrapper; API paths centralized; FormData uploads do not set `Content-Type`.
- Loading/error states handled; PropTypes/types present; no stray `console.log` or dead code.

**Contract (backend ↔ frontend)**
- Frontend payloads, param names, and response handling match the backend endpoints (shapes, nesting, status codes).

## Report findings

Produce a report grouped by severity. For each finding give `repo path:line`, what is wrong, and the fix.

- **Critical** — bugs, security holes, data loss, or missing plan items. **Blocks finishing.**
- **Major** — convention violations, N+1s, missing tests, contract mismatches. **Blocks finishing.**
- **Minor / Nit** — style, naming, small improvements. Advisory.

## Resolve before finishing

If there are Critical or Major findings, fix them — loop back to `kantan-backend-tdd` / `kantan-frontend`, following TDD and the repo's conventions — then re-run tests and linters and re-check. Only once no blocking findings remain, proceed to `kantan-finish-feature`.

Do NOT run `git add` or `git commit`. Leave changes for the user to review.
