#!/usr/bin/env bash
# Applies Montessori Keyboard's GitHub settings: develop as the default branch, merge settings, and the
# develop and main rulesets. Safe to run again: rulesets are found by name and updated, never duplicated.
# Needs `gh`, signed in as an admin of the repository. Adapted from Galley's scripts/github-setup.sh.
#
#   scripts/github-setup.sh                     # renaissanceabc/montessori-keyboard
#   scripts/github-setup.sh owner/repo
#   scripts/github-setup.sh --with-devkit       # also require devkit's Promotion Source and Staging Green
#
# Required checks: `Check` (the CI workflow) on both branches. The iOS workflow only runs when apps/ios
# changes, so it isn't required: a required check that never reports would block every other PR.
# Pass --with-devkit once devkit is synced, so its promotion checks report. Karel applies this; agents
# never change rulesets themselves.
set -euo pipefail

repo="renaissanceabc/montessori-keyboard"
devkit=false

for arg in "$@"; do
  case "$arg" in
    --with-devkit) devkit=true ;;
    -h | --help)
      sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    -*)
      echo "Unknown option: $arg" >&2
      exit 2
      ;;
    *) repo="$arg" ;;
  esac
done

command -v gh > /dev/null || {
  echo "Needs the GitHub CLI (gh)." >&2
  exit 1
}

echo "Settings for $repo"

gh api "repos/$repo/branches/develop" --silent || {
  echo "No develop branch yet. Push develop and run this again." >&2
  exit 1
}

gh api --method PATCH "repos/$repo" --silent --input - << JSON
{
  "default_branch": "develop",
  "allow_squash_merge": true,
  "allow_merge_commit": true,
  "allow_rebase_merge": false,
  "squash_merge_commit_title": "PR_TITLE",
  "squash_merge_commit_message": "PR_BODY",
  "merge_commit_title": "PR_TITLE",
  "merge_commit_message": "PR_BODY",
  "delete_branch_on_merge": true,
  "allow_auto_merge": true,
  "allow_update_branch": true
}
JSON
echo "  Default branch develop. Squash and merge commits, no rebase, PR title and body, delete branches, auto-merge, update branch."

if $devkit; then
  develop_checks='[{ "context": "Check" }, { "context": "Promotion Source" }]'
  main_checks='[{ "context": "Check" }, { "context": "Promotion Source" }, { "context": "Staging Green" }]'
else
  develop_checks='[{ "context": "Check" }]'
  main_checks='[{ "context": "Check" }]'
fi

# One branch's ruleset: no deletion or force-push, changes by pull request with resolved threads, and the
# required checks. Org admins bypass only through a pull request.
ruleset() {
  local name="$1" approvals="$2" strict="$3" methods="$4" checks="$5"
  cat << JSON
{
  "name": "$name",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["refs/heads/$name"], "exclude": [] } },
  "bypass_actors": [
    { "actor_id": null, "actor_type": "OrganizationAdmin", "bypass_mode": "pull_request" }
  ],
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": $approvals,
        "dismiss_stale_reviews_on_push": false,
        "required_reviewers": [],
        "require_code_owner_review": false,
        "dismissal_restriction": { "enabled": false, "allowed_actors": [] },
        "require_last_push_approval": false,
        "required_review_thread_resolution": true,
        "require_extra_approval_for_unattributed_changes": true,
        "allowed_merge_methods": $methods
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": $strict,
        "do_not_enforce_on_create": false,
        "required_status_checks": $checks
      }
    }
  ]
}
JSON
}

apply() {
  local name="$1" id
  id="$(gh api "repos/$repo/rulesets" --paginate --jq ".[] | select(.name == \"$name\") | .id" | head -n 1)"
  if [ -n "$id" ]; then
    gh api --method PUT "repos/$repo/rulesets/$id" --silent --input -
    echo "  Ruleset $name: updated ($id)."
  else
    gh api --method POST "repos/$repo/rulesets" --silent --input -
    echo "  Ruleset $name: created."
  fi
}

# Into develop: squash (or a merge commit for a back-merge), up to date with develop, no approval needed.
ruleset develop 0 true '["squash", "merge"]' "$develop_checks" | apply develop
# Into main: promotions are merge commits, with one approval (Karel).
ruleset main 1 false '["merge"]' "$main_checks" | apply main

echo "Done."
