---
name: kantan-finish-feature
description: Use when a feature is complete or wrapping up implementation in a Rails + React app. Records how the feature was built as a docs file and captures new reusable patterns into each repo's conventions file.
---

# Finish a Feature

Run this after `kantan-review-feature` has passed (no Critical or Major findings remaining) and tests and linters are green on both stacks.

## Gate: verify the review happened

Before anything else, read `<backend-root>/.kantan-dev/reviews/YYYYMMDD_feature_name.md` (same slug as the idea/plan).

- If the file **does not exist**, STOP — the feature has not been reviewed. Run `kantan-review-feature` first, then return here.
- If the file exists but its verdict is **not** `Verdict: APPROVED`, STOP — blocking findings remain. Resolve them via the review loop first.
- If it has a **"Deferred — needs your call"** section, repeat those items to the user now, in your own message, before writing anything. They are decisions the review left open; do not let them pass as closed just because the verdict is `APPROVED`.
- Do not skip this gate on your own judgment; only an explicit user instruction can override it.

## Gate: verify the schema file

From the backend root, run the schema regeneration script bundled with `kantan-backend-tdd`, with the base branch from the `Branches` section of the IDEA:

```bash
<kantan-backend-tdd skill directory>/scripts/regenerate_schema.sh <base-branch>
```

It rebuilds the test database from the base branch's schema, runs this branch's migrations on it, and dumps the result; it never touches the development database. Read its last line:

- `unchanged:` or `skip:` — the schema file is correct. Continue.
- Anything else — STOP. The schema file the review approved did not match this branch's migrations. The script has already corrected the file; re-run the backend suite and `kantan-review-feature`, then return here.

## Write it in plain English

Write every document and chat message from this skill in **ASD-STE100 Simplified Technical English** — a restricted form of English built for technical documents that a non-native reader must get right on one reading. Later agent sessions read these files too.

- **Active voice, named actor.** "The service rejects the request" — not "the request is rejected".
- **One idea per sentence.** Aim for 20 words or fewer.
- **One word, one meaning.** Pick a term and repeat it verbatim; never vary it for elegance — `endpoint` stays "endpoint", never "route" or "API surface".
- **Explain each technical term once,** where it first appears. Use it bare after that.
- **Present tense; imperative for steps.** "Run the suite" — not "the suite should be run".
- **Never simplify code.** Identifiers, paths, commands, and quoted output stay exactly as they are.

## 1. Write the implementation doc

Create `<backend-root>/.kantan-dev/docs/YYYYMMDD_feature_name.md` (same slug as the idea/plan). One consolidated doc covering backend and frontend. Include:

- Summary of what was built
- Key architectural decisions and why
- Files created/modified (brief descriptions), backend and frontend
- API endpoints added or changed
- Service objects / frontend state approach and their responsibilities
- Database migrations (if any), and confirmation that the schema file was regenerated from the base branch
- Gotchas, trade-offs, known limitations
- How to test or verify the feature

Purpose: future agent sessions read these for context. Be concrete.

## 2. Update conventions

Review the changes for anything **generic and reusable** (not feature-specific): new service/controller/model patterns, testing helpers, component/API/state patterns, library integrations, migration conventions.

For each reusable pattern, update the relevant repo's conventions file — write to `AGENTS.md` if it exists, otherwise `CLAUDE.md`. Backend patterns go in the backend's file; frontend patterns go in that frontend's file. Keep entries concise and prescriptive (tell future agents what to do, not what was done).

## Guardrail

Do NOT run `git add` or `git commit`. Leave all changes — code, docs, and conventions updates — for the user to review and push.
