#!/bin/bash
# Run this in Git Bash (right-click the Whatsmyglucose folder → "Git Bash Here")
# GitHub Desktop must be installed and signed in — it handles authentication automatically.

echo "=== WhatsmyGlucose — GitHub Push + Pages Deploy ==="
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
  git commit -m "WhatsmyGlucose: deploy glucose dashboard"

# Set remote (fixed: correct GitHub username is hauptcc)
git remote remove origin 2>/dev/null
git remote add origin https://github.com/hauptcc/whatsmyglucose.git

echo ""
echo "Checking if GitHub repo exists..."
# Try to create the repo via gh CLI (no-op if it already exists)
if command -v gh &>/dev/null; then
  gh repo create hauptcc/whatsmyglucose --public --description "WhatsmyGlucose CGM Dashboard" 2>/dev/null \
    && echo "Repo created on GitHub!" \
    || echo "(Repo already exists — skipping creation)"
else
  echo "NOTE: If the repo doesn't exist yet, go to https://github.com/new"
  echo "      and create a public repo named 'whatsmyglucose', then re-run this script."
  echo ""
fi

echo "Pushing to GitHub..."
git push -u origin main --force

if [ $? -eq 0 ]; then
  echo ""
  echo "=== Push successful! ==="
  echo ""
  echo "Now enabling GitHub Pages..."

  # Enable Pages via gh CLI (if available)
  if command -v gh &>/dev/null; then
    gh api repos/hauptcc/whatsmyglucose/pages \
      -X POST \
      -f "source[branch]=main" \
      -f "source[path]=/" \
      2>/dev/null && echo "GitHub Pages enabled!" || \
      echo "(Pages may already be enabled — check https://github.com/hauptcc/whatsmyglucose/settings/pages)"
  else
    echo "gh CLI not found. Enable Pages manually:"
    echo "  1. Go to https://github.com/hauptcc/whatsmyglucose/settings/pages"
    echo "  2. Under 'Branch', select 'main' and '/ (root)'"
    echo "  3. Click Save"
  fi

  echo ""
  echo "Your dashboard URL (live in ~60 seconds):"
  echo "  https://hauptcc.github.io/whatsmyglucose/"
else
  echo ""
  echo "Push failed. Make sure GitHub Desktop is signed in and try again."
fi
