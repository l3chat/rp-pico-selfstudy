#!/usr/bin/env bash
# =============================================================================
# bootstrap-02-remote.sh
# =============================================================================
#
# PHASE 2 PURPOSE
# ---------------
# Phase 2 connects your LOCAL repository (created in Phase 1) to GitHub and
# pushes the current branch to the remote.
#
# VERY IMPORTANT LIMITATION
# -------------------------
# This script DOES NOT create a GitHub repository.
# You MUST create the GitHub repository manually first using the GitHub Web UI:
#   GitHub → "+" → "New repository" → create an EMPTY repo (no README, no license)
#
# Why manual?
# - Creating repos requires GitHub API or GitHub CLI auth.
# - We keep Phase 2 simple, tool-free, and beginner friendly.
#
# REQUIRED ORDER
# --------------
# 1) Run: bootstrap-01-local.sh   (creates local repo + first commit)
# 2) Create EMPTY GitHub repo in Web UI
# 3) Run: bootstrap-02-remote.sh  (this script)
#
# WHAT THIS SCRIPT DOES
# ---------------------
# - Verifies .git exists and there is at least one commit
# - Asks for REMOTE_URL (or uses env var REMOTE_URL)
# - Adds/updates the 'origin' remote
# - Ensures branch name is 'main'
# - Pushes and sets upstream: git push -u origin main
#
# INPUT
# -----
# Option A (recommended): interactive prompt
# Option B: provide env var:
#   REMOTE_URL="git@github.com:USER/REPO.git" bash bootstrap-02-remote.sh
#
# EXAMPLES
# --------
# SSH:   git@github.com:l3chat/rp-pico-selfstudy.git
# HTTPS: https://github.com/l3chat/rp-pico-selfstudy.git
#
# =============================================================================

set -euo pipefail

# ---- Must be run inside an existing local git repo ---------------------------
if [[ ! -d ".git" ]]; then
  echo "ERROR: No .git directory found."
  echo "You must run Phase 1 first: bash bootstrap-01-local.sh"
  exit 1
fi

# ---- Must have at least one commit (Phase 1 should have created it) ----------
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "ERROR: This repo has no commits (HEAD not found)."
  echo "Run Phase 1 first to create the initial commit."
  exit 1
fi

# ---- Loud reminder about manual GitHub repo creation -------------------------
cat <<'TXT'
================================================================================
PHASE 2 REMINDER: GitHub repository must be created manually (Web UI)
--------------------------------------------------------------------------------
This script will NOT create a GitHub repository for you.

Before continuing:
1) Open GitHub in your browser
2) Create a NEW repository (empty):
   - Do NOT add README
   - Do NOT add .gitignore
   - Do NOT add License
3) Copy the repository URL (SSH or HTTPS)
================================================================================
TXT

# ---- Collect remote URL ------------------------------------------------------
REMOTE_URL="${REMOTE_URL:-}"

if [[ -z "$REMOTE_URL" ]]; then
  echo
  echo "Enter the Git remote URL for 'origin'. Examples:"
  echo "  SSH:   git@github.com:USER/REPO.git"
  echo "  HTTPS: https://github.com/USER/REPO.git"
  echo
  read -r -p "REMOTE_URL: " REMOTE_URL
fi

if [[ -z "$REMOTE_URL" ]]; then
  echo "ERROR: REMOTE_URL is empty. Aborting."
  exit 1
fi

# ---- Set or update remote ----------------------------------------------------
if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote 'origin' already exists; updating its URL."
  git remote set-url origin "$REMOTE_URL"
else
  echo "Adding remote 'origin'."
  git remote add origin "$REMOTE_URL"
fi

# ---- Ensure branch is main ---------------------------------------------------
# This keeps the course consistent and avoids 'master' vs 'main' confusion.
git branch -M main

# ---- Push -------------------------------------------------------------------
echo
echo "Pushing 'main' to origin and setting upstream..."
git push -u origin main

echo
echo "✅ Phase 2 complete."
echo "Remote origin:"
echo "  $REMOTE_URL"