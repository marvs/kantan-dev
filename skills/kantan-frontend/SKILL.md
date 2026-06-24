---
name: kantan-frontend
description: Use when implementing React frontend changes — components, hooks, pages, or UI. Follows the frontend repo's own stack and conventions, and keeps the formatter and linter clean.
---

# Frontend Implementation

For React frontend work. Detect the frontend by a `package.json` that depends on React. If more than one React frontend exists in the workspace and the target is ambiguous, confirm which one before editing — do not guess.

## Follow the repo first

Before writing code, read the frontend repo's conventions file — `AGENTS.md` if present, else `CLAUDE.md`. Frontends differ a lot (e.g. SWR vs Redux, `sx` vs makeStyles, quote/print-width rules, Node version, data-fetching helpers). Follow *that repo's* stack and conventions exactly. Do not impose conventions from memory.

## Implement

- Build the changes per the approved plan and the repo's component, state, and API patterns.
- Reuse existing components, helpers, and API path constants instead of creating new ones.

## Before frontend work is done

1. **Format then lint:** run the detected formatter first, then the linter (e.g. Prettier, then ESLint), using the repo's configured commands. Resolve all issues.
2. If a build or type check is the project's verification step, run it when needed.
3. Use the exact commands from the repo's conventions file — do not invent commands.

Do NOT run `git add` or `git commit`. Leave changes for the user to review.
