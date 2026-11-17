#!/bin/sh
# Vercel's Ignored Build Step (vercel.json "ignoreCommand"), run from apps/site before install.
# Exit 0 skips the deployment; exit 1 builds. It builds when the site's `build` task is
# affected: a change that matches its `inputs` in apps/site/turbo.json, a dependency the
# site uses, or the root package.json, turbo.json or bun.lock. Swift, iOS, docs and CI
# changes skip. Any error (turbo exits 2, or a missing ref) builds, so a deploy is never lost.

# The last commit this branch deployed; a branch's first deployment compares with its parent.
base="${VERCEL_GIT_PREVIOUS_SHA:-HEAD^1}"

# The same turbo the repo pins; nothing is installed yet, so npx fetches it.
version=$(node -p 'require("../../package.json").devDependencies.turbo') || exit 1

npx -y "turbo@$version" query affected \
  --tasks build --packages @montessori-keyboard/site \
  --base "$base" --head HEAD --exit-code
code=$?

case $code in
  0) echo "Site not affected since $base: skipping the build." ;;
  1) echo "Site affected since $base: building." ;;
  *) echo "turbo query failed ($code): building to be safe."; exit 1 ;;
esac
exit $code
