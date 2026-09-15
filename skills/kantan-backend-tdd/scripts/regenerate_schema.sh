#!/usr/bin/env bash
#
# Regenerate the Rails schema file (db/schema.rb or db/structure.sql) so that
# its diff against the base branch contains only this branch's migrations.
#
# Usage:   regenerate_schema.sh <base-branch>
#   Run it from the Rails backend root (the directory with the Gemfile).
#   <base-branch> is the branch this feature merges into (e.g. main, origin/main).
#   RAILS_CMD overrides the Rails command (default: bin/rails). It must accept
#   `runner` and `db:*` tasks and must pass RAILS_ENV through to Rails.
#
# How it works:
#   1. Find the migrations this branch added, edited, or deleted (committed,
#      staged, or untracked) relative to the merge-base with <base-branch>.
#   2. Replace the schema file with the base branch's copy.
#   3. Rebuild the TEST database from that copy (db:test:prepare purges it
#      first), forget the versions of this branch's new migrations (the schema
#      load marks every migration file older than the schema version as already
#      run), then run this branch's migrations and dump the schema from the
#      test database.
#
# The development database is never touched. The test database is disposable:
# the next test run reloads it from the new schema file. A failure restores the
# previous schema file. Multi-database apps: this handles the primary database.
#
# Exit status 0 on success. Its last line starts with one of:
#   unchanged:  the schema file already matched base + this branch's migrations
#   updated:    the schema file was rewritten; review it with git diff
#   skip:       nothing to do in this repo

set -euo pipefail

BASE_BRANCH="${1:-}"
read -ra RAILS <<< "${RAILS_CMD:-bin/rails}"
export RAILS_ENV=test

if [ -z "$BASE_BRANCH" ]; then
  echo "usage: $0 <base-branch>" >&2
  exit 2
fi
if [ ! -f Gemfile ]; then
  echo "error: run this script from the Rails backend root (no Gemfile in $PWD)" >&2
  exit 2
fi

# --- Which schema file does this repo track? ---------------------------------
if git ls-files --error-unmatch db/structure.sql >/dev/null 2>&1; then
  SCHEMA=db/structure.sql
elif git ls-files --error-unmatch db/schema.rb >/dev/null 2>&1; then
  SCHEMA=db/schema.rb
else
  echo "skip: neither db/schema.rb nor db/structure.sql is tracked by git"
  exit 0
fi

# --- Base commit ---------------------------------------------------------------
if ! BASE=$(git merge-base "$BASE_BRANCH" HEAD 2>/dev/null); then
  echo "error: no merge-base between '$BASE_BRANCH' and HEAD (try origin/$BASE_BRANCH)" >&2
  exit 2
fi
if ! git cat-file -e "$BASE:./$SCHEMA" 2>/dev/null; then
  echo "skip: $SCHEMA does not exist on $BASE_BRANCH (merge-base ${BASE:0:12}); regenerate it by hand"
  exit 0
fi

# --- Migration changes on this branch (committed, staged, or untracked) -------
base_migrations=$(git ls-tree -r --name-only "$BASE" -- db/migrate | sort)
current_migrations=$(find db/migrate -maxdepth 1 -name '*.rb' 2>/dev/null | sort)
added=$(comm -13 <(echo "$base_migrations") <(echo "$current_migrations") | sed '/^$/d')
changed=$(
  {
    git diff --name-only --relative "$BASE" -- db/migrate
    git ls-files --others --exclude-standard -- db/migrate
  } | sed '/^$/d' | sort -u
)

if [ -z "$changed" ]; then
  if git diff --quiet "$BASE" -- "$SCHEMA"; then
    echo "unchanged: no migration changes on this branch and $SCHEMA matches $BASE_BRANCH"
  else
    git show "$BASE:./$SCHEMA" > "$SCHEMA"
    echo "updated: $SCHEMA differed from $BASE_BRANCH but this branch has no migration changes; restored the base copy"
  fi
  exit 0
fi

echo "==> migrations changed on this branch (vs $BASE_BRANCH, merge-base ${BASE:0:12}):"
echo "$changed" | sed 's/^/    /'

# --- Backup, and restore it if anything below fails ---------------------------
BACKUP=$(mktemp)
cp "$SCHEMA" "$BACKUP"
cleanup() {
  status=$?
  if [ "$status" -ne 0 ]; then
    cp "$BACKUP" "$SCHEMA"
    echo "failed: restored the previous $SCHEMA" >&2
  fi
  rm -f "$BACKUP"
  exit "$status"
}
trap cleanup EXIT

# --- Guard: the Rails command must really run in the test environment --------
echo "==> checking the target database"
"${RAILS[@]}" runner '
  abort "refusing: Rails.env is #{Rails.env.inspect}, expected \"test\" (does your RAILS_CMD pass RAILS_ENV through?)" unless Rails.env.test?
  puts "    env: #{Rails.env}, database: #{ActiveRecord::Base.connection_db_config.database}"
'

# --- Rebuild the test database from the base schema (db:test:prepare purges it) --
echo "==> rebuilding the test database from the $BASE_BRANCH copy of $SCHEMA"
git show "$BASE:./$SCHEMA" > "$SCHEMA"
"${RAILS[@]}" db:test:prepare

# --- Forget this branch's new migration versions so db:migrate runs them -----
if [ -n "$added" ]; then
  versions=$(echo "$added" | sed -E 's#.*/([0-9]+)_[^/]*\.rb$#\1#' | tr '\n' ' ')
  echo "==> clearing schema_migrations for new versions: $versions"
  KANTAN_VERSIONS="$versions" "${RAILS[@]}" runner '
    versions = ENV.fetch("KANTAN_VERSIONS").split
    conn = ActiveRecord::Base.connection
    table = conn.quote_table_name("#{ActiveRecord::Base.table_name_prefix}schema_migrations#{ActiveRecord::Base.table_name_suffix}")
    conn.execute("DELETE FROM #{table} WHERE version IN (#{versions.map { |v| conn.quote(v) }.join(", ")})")
  '
fi

# --- Run this branch's migrations and dump the schema ------------------------
echo "==> running migrations and dumping $SCHEMA from the test database"
"${RAILS[@]}" db:migrate db:schema:dump

# --- Verify ---------------------------------------------------------------------
if [ -n "$added" ] && git diff --quiet "$BASE" -- "$SCHEMA"; then
  echo "error: $SCHEMA is identical to $BASE_BRANCH although this branch adds migrations; they did not run" >&2
  exit 1
fi
if [ -z "$added" ] && git diff --quiet "$BASE" -- "$SCHEMA"; then
  echo "warning: this branch edits or deletes migrations that already exist on $BASE_BRANCH; the regenerated $SCHEMA equals the base copy, review those migrations by hand" >&2
fi

git --no-pager diff --stat "$BASE" -- "$SCHEMA"
echo "==> the test database now holds base + this branch's migrations; the next test run reloads it from $SCHEMA"
if cmp -s "$BACKUP" "$SCHEMA"; then
  echo "unchanged: $SCHEMA already matched $BASE_BRANCH + this branch's migrations"
else
  echo "updated: $SCHEMA regenerated from $BASE_BRANCH + this branch's migrations; review it with: git diff $BASE -- $SCHEMA"
fi
