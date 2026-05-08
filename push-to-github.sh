#!/bin/bash
# Run this in Git Bash (right-click the Whatsmyglucose folder → "Git Bash Here")
# GitHub Desktop must be installed and signed in — it handles authentication automatically.

echo "=== WhatsmyGlucose — GitHub Push ==="
cd "$(dirname "$0")"

# Clean up any stale lock files
rm -f .git/config.lock .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock 2>/dev/null

# Initialise (safe to run on existing repo)
git init -b main
git config user.email "hauptcc@gmail.com"
git config user.name "CCHaos"

# Stage all files
git add -A

# Commit if anything changed
git diff --cached --quiet && echo "(Nothing new to commit — already up to date)" || \
  git commit -m "WhatsmyGlucose: update site"

# Set remote — correct GitHub username is hauptcc-svg
git remote remove origin 2>/dev/null
git remote add origin https://github.com/hauptcc-svg/whatsmyglucose.git

echo ""
echo "Pushing to GitHub..."
git push -u origin main --force

if [ $? -eq 0 ]; then
  echo ""
  echo "=== Push successful! ==="
  echo "Vercel will auto-deploy in ~30 seconds:"
  echo "  https://whatsmyglucose.vercel.app"
else
  echo ""
  echo "Push failed. Make sure GitHub Desktop is signed in and try again."
fi
