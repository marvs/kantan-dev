# Kantan Dev

A lean, opinionated feature workflow for **Rails backend + React frontend** projects, packaged as an installable plugin for Claude Code, Cursor, and Codex.

Kantan Dev guides a feature from idea → plan → test-driven backend → frontend → a written record, while **deferring to each repo's own conventions** (`AGENTS.md` / `CLAUDE.md`). It deliberately stays small to save tokens: skills activate on demand via their description; there is no always-on bootstrap.

## The workflow

1. **`kantan-start-feature`** — name the feature, stay on the current branch (no worktrees), capture detailed requirements as an IDEA.
2. **`kantan-plan-feature`** — read the idea + prior docs + repo conventions, ask clarifying questions (never assume), write a plan, and wait for approval.
3. **`kantan-backend-tdd`** — implement Rails code with TDD; keep RSpec (or the detected suite) and RuboCop (if present) green.
4. **`kantan-frontend`** — implement React changes following the frontend repo's stack; run its formatter then linter.
5. **`kantan-finish-feature`** — write a "how it was built" doc and fold new reusable patterns into each repo's conventions file.

**Guardrails:** never use git worktrees; never `git add`/`commit` — the user reviews and pushes.

## Artifacts

All per-feature artifacts live in the **backend root** (the root with a `Gemfile`, or any root that already has a `.kantan-dev/` directory):

| Artifact | Location |
| --- | --- |
| Idea | `<backend>/.kantan-dev/ideas/YYYYMMDD_feature_name.md` |
| Plan | `<backend>/.kantan-dev/plans/YYYYMMDD_feature_name.md` |
| Doc (how-built) | `<backend>/.kantan-dev/docs/YYYYMMDD_feature_name.md` |
| Reusable patterns | each repo's `AGENTS.md` (or `CLAUDE.md` if that's what exists) |

## Installation

### Claude Code

```text
/plugin marketplace add marvs/kantan-dev
/plugin install kantan@kantan-dev
```

Update later:

```text
/plugin marketplace update kantan-dev
```

### Codex

Add the plugin from this repository via the plugin manager:

```text
/plugins
```

Then add `github.com/marvs/kantan-dev` (or install it from the official `openai/plugins` marketplace once listed).

### Cursor

Cursor's marketplace requires review before `/add-plugin kantan` works publicly. Until then, install locally:

```bash
git clone https://github.com/marvs/kantan-dev ~/.cursor/plugins/local/kantan-dev
```

Then restart Cursor (or run **Developer: Reload Window**). Once published, install via the marketplace / `/add-plugin kantan`.

## Updating

Bump `version` in the three manifests (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.cursor-plugin/plugin.json`, `.codex-plugin/plugin.json`) and push. Users pull the new version through their platform's plugin update flow. (For rapid iteration on Claude Code you may omit `version` so each commit counts as an update.)

## Design notes

- **Process here, conventions in the repo.** Skills never hardcode stack conventions (quote style, SWR vs Redux, test commands, etc.). They read the target repo's `AGENTS.md`/`CLAUDE.md` and follow it. This lets one plugin serve very different Rails and React repos.
- **Backend is canonical** for `.kantan-dev/` artifacts because it houses the business logic.
- **No anti-rationalization prompting / no hooks** — kept lean on purpose; skills rely on native, description-based activation.

## License

MIT — see [LICENSE](LICENSE).
