#!/usr/bin/env bash
# Merge upstream/main into the current branch and rebuild the MCP CLI.
# Never forces: skips a dirty tree, aborts a conflicting merge, exits 0 if the repo is missing.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
if [ ! -d "$repo/.git" ]; then
  echo "kiro-auto-update: repo not found at $repo, skipping."
  exit 0
fi
cd "$repo"

if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  echo "kiro-auto-update: uncommitted changes, skipping." >&2
  exit 0
fi

git fetch upstream --quiet
behind=$(git rev-list --count HEAD..upstream/main)
if [ "$behind" -eq 0 ]; then
  echo "kiro-auto-update: up to date with upstream/main."
  exit 0
fi

echo "kiro-auto-update: merging $behind upstream commit(s)."
if ! git merge --no-edit upstream/main; then
  git merge --abort
  echo "kiro-auto-update: merge conflict, aborted. Resolve by hand." >&2
  exit 1
fi

cargo build --release -p effectcraft-cli
echo "kiro-auto-update: merged and rebuilt. Push with: git push origin HEAD"
