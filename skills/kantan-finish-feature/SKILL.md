---
name: kantan-finish-feature
description: Use when a feature is complete or wrapping up implementation in a Rails + React app. Records how the feature was built as a docs file and captures new reusable patterns into each repo's conventions file.
---

# Finish a Feature

Run this after `kantan-review-feature` has passed (no Critical or Major findings remaining) and tests and linters are green on both stacks.

## 1. Write the implementation doc

Create `<backend-root>/.kantan-dev/docs/YYYYMMDD_feature_name.md` (same slug as the idea/plan). One consolidated doc covering backend and frontend. Include:

- Summary of what was built
- Key architectural decisions and why
- Files created/modified (brief descriptions), backend and frontend
- API endpoints added or changed
- Service objects / frontend state approach and their responsibilities
- Database migrations (if any)
- Gotchas, trade-offs, known limitations
- How to test or verify the feature

Purpose: future agent sessions read these for context. Be concrete.

## 2. Update conventions

Review the changes for anything **generic and reusable** (not feature-specific): new service/controller/model patterns, testing helpers, component/API/state patterns, library integrations, migration conventions.

For each reusable pattern, update the relevant repo's conventions file — write to `AGENTS.md` if it exists, otherwise `CLAUDE.md`. Backend patterns go in the backend's file; frontend patterns go in that frontend's file. Keep entries concise and prescriptive (tell future agents what to do, not what was done).

## Guardrail

Do NOT run `git add` or `git commit`. Leave all changes — code, docs, and conventions updates — for the user to review and push.
