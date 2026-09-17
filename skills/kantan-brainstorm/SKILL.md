---
name: kantan-brainstorm
description: Use ONLY when the user explicitly says "brainstorm" or "brainstorming" about a feature or change (e.g. "I want to brainstorm a payment gateway", "let's brainstorm this"). Optional first step of the Kantan workflow — it explores three independent takes on a rough idea, writes no file, and produces no requirements. If the user does not say "brainstorm", use kantan-start-feature instead, including for "let's build X", "new feature", and "I want to explore X".
---

# Brainstorm a Feature

Optional. Runs before `kantan-start-feature`, when the user has a rough idea and no settled requirements yet.

This step writes **no file** and produces **no requirements**. It ends in one of two places: the user stops, or the user carries the parts they chose into `kantan-start-feature`.

## When this skill applies

Only when the user's own words contain "brainstorm" or "brainstorming". Every other opening — "let's build X", "new feature", "I want to explore X" — goes to `kantan-start-feature`. Do not offer to brainstorm on your own, and do not route a user here who did not ask for it.

## Steps

1. **Take the subject and the name from the user's phrasing.** "I want to brainstorm adding a payment gateway" gives the subject *payment gateway* and the name `payment_gateway`. State the name you derived in one line and move on — do not stop and wait for confirmation. The user corrects it if it is wrong. `kantan-start-feature` reuses this name as the `feature_name` half of its `YYYYMMDD_feature_name` slug.

2. **Collect the stack facts once, yourself.** The three lenses must not each re-discover the repo — that is where the tokens go. Read only what you need: the backend `Gemfile`, the frontend `package.json` (the one depending on `react`), and each root's `AGENTS.md` (or `CLAUDE.md` if that is what exists). From that, write one short brief: the languages and framework versions, the state and HTTP libraries, and any existing domain concept the subject touches. Keep the brief under 200 words.

   If more than one React frontend exists, name them both in the brief. Do not stop to ask which one — this step chooses nothing and writes nothing, so it does not need the answer. `kantan-start-feature` asks later.

3. **Run three independent lenses.**

   - **Lens A — Simplicity.** The smallest thing that solves the problem. What can be left out, deferred, or bought instead of built.
   - **Lens B — Scalability and security.** Load, data growth, and failure. Who is allowed to do what. Secrets, personal data, and the blast radius when something goes wrong.
   - **Lens C — User-friendliness.** The person who uses this. The path through it, what they see when it is slow or broken, and what they have to understand to succeed.

   **Independence is the point of this step — not speed.** Three takes that have read each other are one take with three headings. So:

   - Each lens gets the brief from step 2 and its own lens description. Nothing else. Never pass one lens's output to another, never summarize what another lens said, and never run them where they can see each other's answers.
   - **Where the host supports subagents** (Claude Code's `Task` tool), spawn three in parallel, one per lens. Give each **read-only** tools — no `Write`, no `Edit`, no commands that change the repo. They explore and report; they do not build.
   - **Where the host has no subagents** (Cursor, Codex), take each lens in turn yourself. Write each one out in full before you begin the next, and never revise an earlier lens after a later one. Tell the user you ran them in sequence, so they know the later lenses were anchored by the earlier ones.
   - Each lens returns **300 to 400 words**: a general direction only. Shape, not design. No file paths, no schemas, no code, and no task breakdown.

4. **Present all three, unedited.** Show each lens's output in full, under its own heading. Do not trim one because it repeats another. Do not merge them.

5. **Name the conflicts.** Add one short section after the three. Say where the lenses actually disagree — the simple answer and the safe answer usually pull apart, and that tension is the product of this step. For each conflict, state what one lens wants, what the other wants, and what the choice costs. **Resolve none of them, and never produce a single combined proposal.** Merging the three throws away the independence you just paid for.

6. **Hand the decision to the user.** Offer exactly two ways out:

   - **Stop here.** Nothing is written. That is a complete outcome, not a failure.
   - **Carry it forward.** The user picks the parts they want, from any lens, in their own words.

   The user picks. You may ask which parts they want to keep. You may **not** assemble a recommended combination, and you may **not** treat a lens's idea as chosen because nobody argued with it.

7. **Hand off only when the user continues.** Run `kantan-start-feature`, reusing the name from step 1. The IDEA records **what the user chose and said** — not a lens's text. `kantan-start-feature`'s rule still holds in full: do not invent, expand, or embellish requirements. If the user's selection is thin, ask them; do not fill the gap from a lens's output.

## This session is not a source of truth

Nothing produced here is a decision by the user, including anything the user did not object to. Brainstorm output carries no authority in any later step. `kantan-review-feature` treats only the idea, the approved plan, and explicit user instructions as settled — a brainstorm is none of those, and it is never a citation.
