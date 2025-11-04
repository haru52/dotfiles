#!/bin/sh

set -e

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not a git repository" >&2
  exit 1
fi

# Get current branch
current_branch=$(git branch --show-current)

# Determine default branch from remote HEAD
default_branch=""
if git symbolic-ref refs/remotes/origin/HEAD > /dev/null 2>&1; then
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short | sed 's|^origin/||')
else
  # If remote HEAD is not set, try to set it automatically
  echo "Remote HEAD is not set. Setting it automatically..."
  git remote set-head origin --auto > /dev/null 2>&1
  if git symbolic-ref refs/remotes/origin/HEAD > /dev/null 2>&1; then
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short | sed 's|^origin/||')
  else
    echo "Error: Could not determine default branch" >&2
    exit 1
  fi
fi

echo "Using default branch: ${default_branch}"

# Protected branches to exclude
protected_branches="main master develop"

# Fetch latest remote changes
echo "Fetching latest remote changes..."
git fetch --prune

# Get list of local branches (excluding current and protected branches)
all_branches=$(git branch --format='%(refname:short)' | grep -v "^${current_branch}$")

# Filter merged branches (including squash merged)
merged_branches=""
for branch in ${all_branches}; do
  # Skip protected branches
  skip=false
  for protected in ${protected_branches}; do
    if [ "${branch}" = "${protected}" ]; then
      skip=true
      break
    fi
  done

  # Also skip branches starting with 'sandbox'
  case "${branch}" in
    sandbox*)
      skip=true
      ;;
    *)
      # Not a sandbox branch, continue with normal processing
      ;;
  esac

  if [ "${skip}" = true ]; then
    continue
  fi

  # Check if branch is merged (normal merge)
  if git branch --merged "origin/${default_branch}" | grep -q "^[* ]*${branch}$"; then
    merged_branches="${merged_branches}${branch}\n"
    continue
  fi

  # Check if branch is squash merged
  # Compare commit messages of the branch with commits in default branch
  # Check both the latest commit (most common in squash merge) and all commits
  is_squash_merged=false

  # First, check the latest commit message (most likely to match in squash merge)
  latest_commit_msg=$(git log --format=%s "${branch}" -1)
  if git log "origin/${default_branch}" --format=%s | grep -qF "${latest_commit_msg}"; then
    is_squash_merged=true
  fi

  # If not found, check all commit messages from the branch
  if [ "${is_squash_merged}" = false ]; then
    branch_commits=$(git log --format=%s "${branch}")
    while IFS= read -r commit_msg; do
      if git log "origin/${default_branch}" --format=%s | grep -qF "${commit_msg}"; then
        is_squash_merged=true
        break
      fi
    done <<EOF
${branch_commits}
EOF
  fi

  if [ "${is_squash_merged}" = true ]; then
    merged_branches="${merged_branches}${branch}\n"
  fi
done

# Remove trailing newline
merged_branches=$(echo "${merged_branches}" | sed '/^$/d')

# Check if there are branches to delete
if [ -z "${merged_branches}" ]; then
  echo "No merged branches to delete."
  exit 0
fi

# Display branches to be deleted
echo "The following branches will be deleted:"
echo "${merged_branches}"
echo ""

# Ask for confirmation
printf "Do you want to delete these branches? (y/N): "
read -r response

case "${response}" in
  [yY]|[yY][eE][sS])
    echo "Deleting branches..."
    echo "${merged_branches}" | while IFS= read -r branch; do
      if [ -n "${branch}" ]; then
        git branch -D "${branch}" && echo "Deleted: ${branch}"
      fi
    done
    echo "Done."
    ;;
  *)
    echo "Cancelled."
    exit 0
    ;;
esac
