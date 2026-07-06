---
name: kantan-plan-feature
description: Use when planning a feature or before writing implementation code in a Rails + React app. Produces an approved implementation plan, asking clarifying questions and grounding the plan in repo conventions and prior feature docs. Never starts implementation.
---

# Plan a Feature

Turn an approved IDEA into a concrete, approved plan. Do not implement from this skill.

## Steps

1. **Read the inputs.**
   - Read the IDEA at `<backend-root>/.kantan-dev/ideas/YYYYMMDD_feature_name.md`.
   - Confirm the involved repos: the backend and the **target frontend**. If more than one React frontend exists and one was not already chosen, ask the user which this feature targets — do not guess.
   - Scan `<backend-root>/.kantan-dev/docs/` for prior features related to this one and read the relevant ones for context.
   - Read each involved repo's conventions file — `AGENTS.md` if present, else `CLAUDE.md` — for both backend and the target frontend, so the plan matches existing patterns (services, testing, API, components, state, styling). Trust `package.json`/lockfile over prose for stack/version facts.

2. **Ask, don't assume.** List every open question and ask the user: requirements, data shapes, naming, edge cases, UX. Do not guess. Wait for answers before finalizing. If the platform has a Plan mode, use it.

3. **Write the plan.** Create `<backend-root>/.kantan-dev/plans/YYYYMMDD_feature_name.md`. Break work into small, ordered tasks. For each task: the file(s) involved, what changes, and how it is verified (test/lint). Cover backend and frontend. Reference the conventions you will follow rather than restating them.

   **Every plan MUST end with these two tasks — they are part of the plan, not optional extras:**
   1. **Code review** — run `kantan-review-feature`. Produces `.kantan-dev/reviews/YYYYMMDD_feature_name.md` with a `Verdict: APPROVED` line. Critical/Major findings block completion.
   2. **Finish** — run `kantan-finish-feature` (implementation doc + conventions updates).

   A plan without these two final tasks is incomplete. Never omit them, and never mark the feature done while they are unfinished.

4. **Stop for approval.** Present the plan and wait for explicit user approval before any implementation. Do not write code until approved.

5. **After approval, follow the plan — all of it.**
   - Build your working todo list directly from the plan's tasks, one todo per task, **including the code review and finish tasks**. Do not author a separate task list that drops steps.
   - Implement backend work via `kantan-backend-tdd` and frontend work via `kantan-frontend` — do not implement inline outside those skills.
   - The feature is not done until `kantan-review-feature` has run with no blocking findings and `kantan-finish-feature` is complete.
