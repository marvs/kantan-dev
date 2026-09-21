---
name: kantan-frontend
description: Use when implementing React frontend changes — components, hooks, pages, or UI. Follows the frontend repo's own stack and conventions, and keeps the formatter and linter clean.
---

# Frontend Implementation

For React frontend work. Detect the frontend by a `package.json` that depends on React. If more than one React frontend exists in the workspace and the target is ambiguous, confirm which one before editing — do not guess.

## Follow the repo first

Before writing code, read the frontend repo's conventions. Start with the entry file — `CLAUDE.md` in Claude Code, `AGENTS.md` in Codex and Cursor; if that file is missing, the other one — and any file it imports. Then read the topic files for the areas you will change: scoped rule files in `.claude/rules/`, `.cursor/rules/`, or a subdirectory's `AGENTS.md`, listed in the entry file's index when it has one. A scoped file loads only after you open a matching file, so read it before you start. Frontends differ a lot (e.g. SWR vs Redux, `sx` vs makeStyles, quote/print-width rules, Node version, data-fetching helpers). Follow *that repo's* stack and conventions exactly. Do not impose conventions from memory.

## Implement

- Build the changes per the approved plan and the repo's component, state, and API patterns.
- Reuse existing components, helpers, and API path constants instead of creating new ones.

## Baseline practices (universal React)

Apply these unless the repo's conventions say otherwise — **repo conventions always win**.

- **Functional components + hooks** only.
- **Centralize HTTP and API paths:** route calls through the repo's HTTP wrapper and its API-path constants; never hardcode URLs or scatter `fetch` in components.
- **Stable list keys** — `key={item.id ?? idx}`, never the bare index for backend-persisted lists.
- **FormData uploads: never set `Content-Type` manually** — let the browser set the multipart boundary.
- **Lazy `useState` initializers** for expensive/derived initial state to avoid stale closures.
- **Defer data fetching** in tabs/drawers until they open; remount via `key` to reset local state when the entity changes.
- **Optimistic updates** should revert on error.
- Don't introduce new state libraries without discussion.

## Before frontend work is done

1. **Format then lint:** run the detected formatter first, then the linter (e.g. Prettier, then ESLint), using the repo's configured commands. Resolve all issues.
2. If a build or type check is the project's verification step, run it when needed.
3. Use the exact commands from the repo's conventions file — do not invent commands.
4. **Leaving an error or warning in place is not your call.** If you do not fix one, prove it pre-dates the branch and carry it into `kantan-review-feature` as an open item. Never record it as decided — the review re-opens it, and only the user closes it.

Do NOT run `git add` or `git commit`. Leave changes for the user to review.

## Implementation done ≠ feature done

A clean formatter and linter complete the *implementation*, not the *feature*. Do not report the feature as done: the feature is only done after `kantan-review-feature` has run with no Critical/Major findings and `kantan-finish-feature` is complete. Keep those as pending todos until they are.

"Formatter and linter are clean" is not a reason to skip review — that is exactly the state review is for. Linters cannot catch design issues, missed plan items, or convention drift.
