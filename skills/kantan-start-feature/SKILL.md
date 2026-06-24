---
name: kantan-start-feature
description: Use when starting a new feature or building something new in a Rails + React app. Confirms the feature name and working branch, then captures detailed initial requirements as an IDEA document before any planning or code.
---

# Start a Feature

Begin every new feature here. This establishes the feature's identity and requirements before planning or code.

## Steps

1. **Get the feature name.** Ask for a short name (e.g. "Task Uploads") if not given. Derive a slug `YYYYMMDD_feature_name` using today's date (UTC) and the snake_cased name (e.g. `20260624_task_uploads`). Reuse this same slug for the plan and docs later.

2. **Locate the roots.**
   - **Backend:** if a `.kantan-dev/` directory already exists in a workspace root, use that root; otherwise use the root containing a `Gemfile` (Rails backend, e.g. has `config/application.rb`). All artifacts live under `<backend-root>/.kantan-dev/`.
   - **Frontend:** find roots with a `package.json` that depends on `react`. **If more than one React frontend is present, ask the user which one this feature targets** — do not guess. Record the chosen frontend root. (Trust `package.json`/lockfile over any prose in docs for stack/version facts.)

3. **Confirm the branches.** Report the **current branch of each involved root** (backend and the chosen frontend) and confirm with the user before proceeding. **Call it out explicitly if a root is on a main branch** (`master`/`main`), since work will land there directly. Work happens on the current branch: do NOT create git worktrees, and do NOT create or switch branches unless the user explicitly asks.

4. **Write the IDEA.** Create `<backend-root>/.kantan-dev/ideas/YYYYMMDD_feature_name.md` with the requirements in as much detail as available:
   - What the feature is and the problem it solves
   - User-facing behavior (backend API + frontend UX)
   - Known constraints, data, and edge cases
   - Open questions
   Focus on *what* and *why*, not implementation.

5. **Hand off to planning.** Once the IDEA is written, plan the feature (see `kantan-plan-feature`). Do not write code yet.
