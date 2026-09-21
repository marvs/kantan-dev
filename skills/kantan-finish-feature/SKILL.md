---
name: kantan-finish-feature
description: Use when a feature is complete or wrapping up implementation in a Rails + React app. Records how the feature was built as a docs file and captures new reusable patterns into each repo's conventions files.
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

Review the changes for anything **generic and reusable**: new service/controller/model patterns, testing helpers, component/API/state patterns, library integrations, migration conventions. Test each candidate: would it apply to a feature that does not exist yet? If not, it is a feature fact — it goes in the step 1 doc, not in the conventions. One exception: a recipe for a recurring change to one subsystem becomes a narrowly scoped topic file (under `domain/` if the repo has that folder).

Backend patterns go in the backend repo; frontend patterns go in that frontend's repo.

### Pick the files your agent loads

Each agent loads a different set of files. The **entry file** loads at the start of every session. **Topic files** hold one topic each and load only when the agent works on files that match their scope.

| You run in  | Entry file                                                      | Topic files                                                              |
| ----------- | --------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Claude Code | `CLAUDE.md`; `AGENTS.md` only when the repo has no `CLAUDE.md` | `.claude/rules/**/*.md`, scoped by a `paths:` list                       |
| Cursor      | `AGENTS.md`                                                     | `.cursor/rules/**/*.mdc`, scoped by `globs:` with `alwaysApply: false`   |
| Codex       | `AGENTS.md`                                                     | `AGENTS.md` in a subdirectory, scoped to that directory                  |

- **Use the row for the agent you run in.** Do not write to another agent's files unless the user tells you to.
- **Follow imports.** If the entry file only imports or points to another file (for example a `CLAUDE.md` that holds `@AGENTS.md`), the rules live in that file. Write there.
- **Both `CLAUDE.md` and `AGENTS.md` exist, and neither imports the other:** write to the entry file in your row. Claude Code does not read `AGENTS.md` when a `CLAUDE.md` exists.
- **The repo has no entry file for your agent.** If the repo has no conventions for any agent, create the entry file from your row at the repo root, and tell the user. If the repo keeps its conventions only for another agent (for example `CLAUDE.md` and `.claude/rules/` while you run in Codex), stop and ask the user where to write. A second set of conventions beside the first drifts out of date.
- **The repo's own rules win.** If the entry file has a section on how to record patterns, follow it where it differs from this one.

### Write each entry

- **Put the pattern in the topic file that fits.** Use the entry file's index of topic files to find it; without an index, list the topic directory. Write to the entry file only when the repo has no topic files for your agent.
- **Create a new topic file only when none fits.** Scope it with the field from the table, and quote each glob. Check that each glob matches real files, for example with `git ls-files ':(glob)app/services/billing/**'`. In Codex, put the new `AGENTS.md` in the deepest directory that holds every file the rule covers. If the entry file has an index, add a row for the new file.
- **Search before you add, and merge instead of appending.** Search the entry file and every topic file for the topic's key terms and identifiers. If an entry exists, extend or correct that entry. Two entries on one topic drift apart and start to contradict each other.
- **Fix what the change makes stale.** When a new pattern replaces an older entry, or this feature moved or removed the code an entry describes, fix or remove that entry in the same change.
- **Keep the entry file small.** Add to it only rules that every session needs, and keep it under 200 lines.
- **Keep each entry short and prescriptive:** the rule, one line of why, and the canonical file. Tell future agents what to do; do not retell the incident.
- **Refer to other entries by file name, never by "above" or "below".** Entries move between files, so a reference by position breaks.
- **Keep the file's structure.** Add the entry under the heading that fits. Do not reorder, rename, or reformat existing sections.

## Guardrail

Do NOT run `git add` or `git commit`. Leave all changes — code, docs, and conventions updates — for the user to review and push.
