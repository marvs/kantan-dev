---
name: kantan-plan-feature
description: Use when planning a feature or before writing implementation code in a Rails + React app. Produces an approved implementation plan, asking clarifying questions and grounding the plan in repo conventions and prior feature docs. Never starts implementation.
---

# Plan a Feature

Turn an approved IDEA into a concrete, approved plan. Do not implement from this skill.

## Write it in plain English

Write every document and chat message from this skill in **ASD-STE100 Simplified Technical English** — a restricted form of English built for technical documents that a non-native reader must get right on one reading. Later agent sessions read these files too.

- **Active voice, named actor.** "The service rejects the request" — not "the request is rejected".
- **One idea per sentence.** Aim for 20 words or fewer.
- **One word, one meaning.** Pick a term and repeat it verbatim; never vary it for elegance — `endpoint` stays "endpoint", never "route" or "API surface".
- **Explain each technical term once,** where it first appears. Use it bare after that.
- **Present tense; imperative for steps.** "Run the suite" — not "the suite should be run".
- **Never simplify code.** Identifiers, paths, commands, and quoted output stay exactly as they are.

## Steps

1. **Read the inputs.**
   - Read the IDEA at `<backend-root>/.kantan-dev/ideas/YYYYMMDD_feature_name.md`.
   - Confirm the involved repos: the backend and the **target frontend**. If more than one React frontend exists and one was not already chosen, ask the user which this feature targets — do not guess.
   - Scan `<backend-root>/.kantan-dev/docs/` for prior features related to this one and read the relevant ones for context.
   - Read each involved repo's conventions, for both backend and the target frontend, so the plan matches existing patterns (services, testing, API, components, state, styling). Start with the entry file — `CLAUDE.md` in Claude Code, `AGENTS.md` in Codex and Cursor; if that file is missing, the other one — and any file it imports. Then read the topic files for the areas the feature touches: scoped rule files in `.claude/rules/`, `.cursor/rules/`, or a subdirectory's `AGENTS.md`, listed in the entry file's index when it has one. A scoped file loads only after you open a matching file, so it is not in your context yet — read it yourself. Trust `package.json`/lockfile over prose for stack/version facts.

2. **Ask, don't assume.** List every open question and ask the user: requirements, data shapes, naming, edge cases, UX. Do not guess. Wait for answers before finalizing. If the platform has a Plan mode, use it.

3. **Write the plan.** Create `<backend-root>/.kantan-dev/plans/YYYYMMDD_feature_name.md`. Break work into small, ordered tasks. For each task: the file(s) involved, what changes, and how it is verified (test/lint). Cover backend and frontend. Reference the conventions you will follow rather than restating them.

   **Attribute every decision the plan records.** Mark the ones the user made (their answers in step 2) as theirs; everything else is your proposal. Only the user's decisions count as settled during `kantan-review-feature` — your own reasoning stays open to challenge there, so do not present it as agreed.

   **Every plan MUST end with these two tasks — they are part of the plan, not optional extras:**
   1. **Code review** — run `kantan-review-feature`. Produces `.kantan-dev/reviews/YYYYMMDD_feature_name.md` with a `Verdict: APPROVED` line. Critical/Major findings block completion.
   2. **Finish** — run `kantan-finish-feature` (implementation doc + conventions updates).

   A plan without these two final tasks is incomplete. Never omit them, and never mark the feature done while they are unfinished.

4. **Stop for approval.** Present the plan and wait for explicit user approval before any implementation. Do not write code until approved.

5. **After approval, follow the plan — all of it.**
   - Build your working todo list directly from the plan's tasks, one todo per task, **including the code review and finish tasks**. Do not author a separate task list that drops steps.
   - Implement backend work via `kantan-backend-tdd` and frontend work via `kantan-frontend` — do not implement inline outside those skills.
   - The feature is not done until `kantan-review-feature` has run with no blocking findings and `kantan-finish-feature` is complete.
