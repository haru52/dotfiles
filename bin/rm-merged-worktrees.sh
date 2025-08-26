#!/bin/sh
set -eu

# Set default branch if not provided
base_branch="${1:-develop}"

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Error: Not in a git repository" >&2
  exit 1
fi

# Fetch latest remote information
echo "Fetching latest remote information..."
git fetch --all --prune

# Check if the remote base branch exists
if ! git show-ref --verify --quiet "refs/remotes/origin/${base_branch}"; then
  echo "Error: Remote branch 'origin/${base_branch}' does not exist" >&2
  exit 1
fi

# Get all worktrees (excluding the main worktree)
worktrees=$(git worktree list --porcelain | grep '^worktree ' | cut -d' ' -f2-)
main_worktree=$(git worktree list --porcelain | head -n1 | cut -d' ' -f2-)

# Process each worktree
for worktree_path in ${worktrees}; do
  # Skip the main worktree
  if [ "${worktree_path}" = "${main_worktree}" ]; then
    continue
  fi

  # Get the branch name for this worktree
  branch=$(git worktree list --porcelain | grep -A2 "^worktree ${worktree_path}$" | grep '^branch ' | cut -d' ' -f2- | sed 's|^refs/heads/||')

  # Skip if no branch is associated (detached HEAD)
  if [ -z "${branch}" ]; then
    continue
  fi

  # Skip if it's the base branch itself
  if [ "${branch}" = "${base_branch}" ]; then
    continue
  fi

  should_remove=false
  remove_reason=""

  # Check if the branch has been merged into the remote base branch (for normal merges)
  # But skip if the branch has no unique commits (just created from base branch)
  if git merge-base --is-ancestor "${branch}" "origin/${base_branch}" 2>/dev/null; then
    # Check if the branch has any commits not in origin/${base_branch}
    commits_ahead=$(git rev-list --count "origin/${base_branch}..${branch}" 2>/dev/null || echo "0")

    if [ "${commits_ahead}" -gt 0 ]; then
      # Branch has unique commits and they're all merged
      should_remove=true
      remove_reason="merged into origin/${base_branch}"
    fi
    # If commits_ahead is 0, the branch is just created from base branch, don't remove
  # Check if the remote branch has been deleted (common after squash merge or PR merge)
  # But only if the branch has been pushed before (has upstream tracking)
  elif ! git show-ref --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null; then
    # Check if the branch has or had an upstream tracking branch
    # by looking at the branch configuration or reflog
    upstream=$(git config --get "branch.${branch}.remote" 2>/dev/null || true)
    merge_ref=$(git config --get "branch.${branch}.merge" 2>/dev/null || true)

    # Only consider it deleted if it was tracking a remote branch
    if [ -n "${upstream}" ] && [ -n "${merge_ref}" ]; then
      should_remove=true
      remove_reason="remote branch deleted (was tracking ${upstream})"
    fi
  fi

  if [ "${should_remove}" = true ]; then
    echo "Removing worktree: ${worktree_path} (branch: ${branch}, reason: ${remove_reason})"

    # Remove the worktree
    git worktree remove "${worktree_path}" --force 2>/dev/null || true

    # Delete the local branch
    git branch -D "${branch}" 2>/dev/null || true
  fi
done

echo "Cleanup complete. Merged worktrees have been removed."
