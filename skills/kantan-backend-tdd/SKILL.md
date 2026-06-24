---
name: kantan-backend-tdd
description: Use when implementing Rails backend code — models, services, controllers, jobs, or APIs. Follows the backend repo's own conventions, applies test-driven development, and keeps the test suite and linter green.
---

# Backend Implementation (TDD)

For Rails backend work. Detect the backend by a `Gemfile`.

## Follow the repo first

Before writing code, read the backend repo's conventions file — `AGENTS.md` if present, else `CLAUDE.md`. Follow its rules for service objects, models, controllers, jobs, testing, and tooling. Repo conventions win over any defaults here.

## TDD cycle

For each unit of behavior:

1. **Red** — write one failing test first, using the repo's test framework and factory/fixture conventions. Run it; confirm it fails for the right reason.
2. **Green** — write the minimal code to pass. Run the test; confirm it passes.
3. **Refactor** — clean up while keeping tests green.

Write tests for every new model, service, job, and endpoint.

## Before backend work is done

1. **Tests:** run the full backend suite using the repo's configured command (e.g. `bundle exec rspec`). All green, no regressions.
2. **Lint:** run the detected linter if available (e.g. `bundle exec rubocop`). Zero offenses; auto-correct safe ones.
3. Use the exact commands defined in the repo's conventions file — do not invent commands.

Do NOT run `git add` or `git commit`. Leave changes for the user to review.
