---
name: kantan-backend-tdd
description: Use when implementing Rails backend code — models, services, controllers, jobs, or APIs. Follows the backend repo's own conventions, applies test-driven development, keeps the test suite and linter green, and regenerates the schema file so it contains only this branch's migrations.
---

# Backend Implementation (TDD)

For Rails backend work. Detect the backend by a `Gemfile`.

## Follow the repo first

Before writing code, read the backend repo's conventions. Start with the entry file — `CLAUDE.md` in Claude Code, `AGENTS.md` in Codex and Cursor; if that file is missing, the other one — and any file it imports. Then read the topic files for the areas you will change: scoped rule files in `.claude/rules/`, `.cursor/rules/`, or a subdirectory's `AGENTS.md`, listed in the entry file's index when it has one. A scoped file loads only after you open a matching file, so read it before you start. Follow their rules for service objects, models, controllers, jobs, testing, and tooling. Repo conventions win over any defaults here.

## TDD cycle

For each unit of behavior:

1. **Red** — write one failing test first, using the repo's test framework and factory/fixture conventions. Run it; confirm it fails for the right reason.
2. **Green** — write the minimal code to pass. Run the test; confirm it passes.
3. **Refactor** — clean up while keeping tests green.

Write tests for every new model, service, job, and endpoint.

## Baseline practices (universal Rails)

Apply these unless the repo's conventions say otherwise — **repo conventions always win**. These are principles; use whatever gem/tool the repo already uses.

- **Fat services, thin controllers.** Business logic lives in callable service objects (`Service.new(args).call`); jobs delegate immediately to a service.
- **Specs are mandatory** for every model/service/job/endpoint; stub all external HTTP (no real network in tests); freeze time for time-dependent tests.
- **DB-level constraints** (NOT NULL, foreign keys) in addition to model validations; reversible migrations. Never edit the schema file (`db/schema.rb` / `db/structure.sql`) by hand — regenerate it (see below).
- **Never return unbounded collections** from an endpoint — paginate.
- **Watch for N+1s:** eager-load associations and Active Storage attachments in serializers; add `.distinct` when filtering across a `has_many :through`; batch per-row aggregates instead of querying per row.
- **Secrets & PII:** store hashed/encrypted, never plaintext; show generated tokens once.
- **Slow external loops:** fan out to per-record jobs (enqueue from the parent, `find_each`) and let errors propagate so the job retries.

## Before backend work is done

1. **Schema file:** regenerate the schema file so its diff against the base branch contains only this branch's migrations. Running `db:migrate` on the shared development database leaks other branches' tables into `db/schema.rb`, so the file in the working tree cannot be trusted. From the backend root, run the script bundled with this skill (`<this skill's directory>/scripts/regenerate_schema.sh`; in Claude Code that is `${CLAUDE_PLUGIN_ROOT}/skills/kantan-backend-tdd/scripts/regenerate_schema.sh`):

   ```bash
   <skill-dir>/scripts/regenerate_schema.sh <base-branch>
   ```

   `<base-branch>` comes from the `Branches` section of the IDEA. The script rebuilds the **test** database from the base branch's schema, runs this branch's migrations on it, and dumps the result. It never touches the development database, restores the previous file if anything fails, and is a no-op when the file is already correct. If the conventions file names a different Rails command (e.g. `bundle exec rails`), pass it as `RAILS_CMD`. A migration that fails here only worked on the developer's database: fix the migration, never the schema file. Run this **before** the suite, so the tests run against the regenerated schema — the same file CI loads.
2. **Tests:** run the full backend suite using the repo's configured command (e.g. `bundle exec rspec`). All green, no regressions.
3. **Lint:** run the detected linter if available (e.g. `bundle exec rubocop`). Zero offenses; auto-correct safe ones.
4. Use the exact commands defined in the repo's conventions file — do not invent commands.
5. **Leaving a failure or offense in place is not your call.** If you do not fix one, prove it pre-dates the branch (stash and re-run) and carry it into `kantan-review-feature` as an open item. Never record it as decided — the review re-opens it, and only the user closes it.

Do NOT run `git add` or `git commit`. Leave changes for the user to review.

## Implementation done ≠ feature done

Green tests and a clean linter complete the *implementation*, not the *feature*. Do not report the feature as done: the feature is only done after `kantan-review-feature` has run with no Critical/Major findings and `kantan-finish-feature` is complete. Keep those as pending todos until they are.

"Tests are green and lint is clean" is not a reason to skip review — that is exactly the state review is for. Tests and linters cannot catch design issues, missed plan items, or convention drift.
