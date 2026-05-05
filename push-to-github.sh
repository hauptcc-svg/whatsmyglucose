#!/bin/bash
# Run this in Git Bash (right-click the Whatsmyglucose folder → Git Bash Here)
# GitHub Desktop must be installed and signed in — it handles authentication automatically.

echo "=== WhatsmyGlucose — GitHub Push ==="
cd "$(dirname "$0")"

# Clean up any stale lock files
rm -f .git/config.lock .git/index.lock 2>/dev/null

# Initialise (safe to run on existing repo)
git init -b main
git config user.email "hauptcc@gmail.com"
git config user.name "CCHaos"

# Stage files
git add index.html glucose-validation.html push-to-github.sh

# Commit if anything changed
git diff --cached --quiet && echo "(Nothing new to commit — already up to date)" || \
  git commit -m "WhatsmyGlucose: full rebuild — quiz, 3D CGM, validation page"

# Set remote
git remote remove origin 2>/dev/null
git remote add origin https://github.com/hauptcc-svg/whatsmyglucose.git

echo ""
echo "Pushing to GitHub..."
git push -u origin main --force

echo ""
echo "Done! https://github.com/hauptcc-svg/whatsmyglucose"
