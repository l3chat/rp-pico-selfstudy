# Codex Prompt Template: Consistency Check

Follow AGENTS.md strictly.

Task:
- Scan the repository for consistency:
  - Every lesson has overview.md and assessment.md
  - Site build succeeds (`./.venv/bin/python scripts/build_site.py` preferred; `python3 scripts/build_site.py` if `.venv` is not used)
  - PLAN.md matches existing lessons
  - MEMORY.md has no contradictions
  - Verify that all list items are on separate lines; flag inline `: -` patterns

Output:
- A short report in Markdown
- A list of proposed fixes (do not apply unless asked)
