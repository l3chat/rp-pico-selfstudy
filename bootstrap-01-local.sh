#!/usr/bin/env bash
# =============================================================================
# bootstrap-01-local.sh
# =============================================================================
#
# PHASE 1 PURPOSE (LOCAL)
# -----------------------
# Phase 1 turns the CURRENT directory into a LOCAL Git repository and creates
# the *very first commit*.
#
# Your requirement:
# - The first commit should contain the bootstrap scripts themselves
#   (so the repo is self-bootstrapping and reproducible).
# - We therefore commit THREE scripts in the first commit:
#     1) bootstrap-01-local.sh   (this script)
#     2) bootstrap-02-remote.sh  (adds remote + pushes)
#     3) bootstrap-03-scaffold.sh (creates course scaffold: AGENTS/PLAN/etc.)
#
# VERY IMPORTANT: ORDER OF EXECUTION
# ----------------------------------
# 1) Phase 1 (this script):
#       bash bootstrap-01-local.sh
#    Result: local git repo + first commit containing the 3 scripts.
#
# 2) Phase 2 (manual GitHub repo creation + push):
#    2.1) Create an EMPTY GitHub repository using the Web UI:
#         GitHub → "+" → New repository → create EMPTY (no README, no license).
#    2.2) Run:
#         bash bootstrap-02-remote.sh
#
# 3) Phase 3 (course scaffold):
#       bash bootstrap-03-scaffold.sh
#    Result: creates README.md, AGENTS.md, MEMORY.md, PLAN.md, lessons/, docs/,
#            .codex prompts, and lesson skeletons. Makes a new commit.
#
# WHY THIS SPLIT EXISTS
# ---------------------
# - Phase 1 is about local git creation and a clean first commit.
# - Phase 2 is about connecting to GitHub (but NOT creating the repo).
# - Phase 3 is about generating the learning-content architecture.
#
# WHERE TO RUN
# ------------
# Run this script from INSIDE the project directory you created beforehand,
# ideally when it is empty except for these scripts.
#
# SAFETY RULES
# ------------
# - Refuses to run in / or $HOME
# - Refuses to run if a .git directory already exists
# - Refuses to run if Phase 2 or Phase 3 scripts are missing (completeness)
#
# =============================================================================

set -euo pipefail

# ---- safety: location checks -------------------------------------------------
CURRENT_DIR="$(pwd)"
if [[ "$CURRENT_DIR" == "/" || "$CURRENT_DIR" == "$HOME" ]]; then
  echo "Refusing to run in '$CURRENT_DIR' (too dangerous)."
  exit 1
fi

# ---- safety: don't re-init an existing repo ---------------------------------
if [[ -d ".git" ]]; then
  echo "A git repository already exists here (.git found)."
  echo "Phase 1 must be run ONLY in a non-git directory. Aborting."
  exit 1
fi

# ---- tool check --------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "git is required but not found."; exit 1; }

# ---- require all phase scripts exist ----------------------------------------
# Your requirement: first commit contains phase 1+2+3 scripts.
[[ -f "./bootstrap-01-local.sh" ]] || { echo "Missing: bootstrap-01-local.sh"; exit 1; }
[[ -f "./bootstrap-02-remote.sh" ]] || { echo "Missing: bootstrap-02-remote.sh"; exit 1; }
[[ -f "./bootstrap-03-scaffold.sh" ]] || { echo "Missing: bootstrap-03-scaffold.sh"; exit 1; }

# ---- initialize local repo ---------------------------------------------------
echo "Initializing local git repository in: $CURRENT_DIR"
git init

# Ensure modern default branch name and avoid master/main confusion later.
git branch -M main

# ---- first commit contains the three bootstrap scripts -----------------------
git add bootstrap-01-local.sh bootstrap-02-remote.sh bootstrap-03-scaffold.sh
git commit -m "Bootstrap phase 1: initialize local repo with phase scripts (01/02/03)"

# ---- friendly, explicit next-step instructions ------------------------------
cat <<'TXT'

✅ Phase 1 complete: local repository created.

What exists now:
- .git/ directory created
- Branch is set to: main
- First commit contains:
  - bootstrap-01-local.sh
  - bootstrap-02-remote.sh
  - bootstrap-03-scaffold.sh

NEXT (Phase 2):
--------------------------------------------------------------------------------
IMPORTANT: Phase 2 WILL NOT create a GitHub repository.

You must create the GitHub repository manually in the Web UI:
  GitHub → "+" → New repository → create an EMPTY repo
  (do NOT add README, .gitignore, or License)

Then run:
  bash bootstrap-02-remote.sh

NEXT (Phase 3):
--------------------------------------------------------------------------------
After Phase 2 (or even without it, if you want to stay local), create the course
scaffold by running:
  bash bootstrap-03-scaffold.sh

TXT