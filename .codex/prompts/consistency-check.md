# Codex Prompt Template: Consistency Check

Follow AGENTS.md strictly.

Task:
- Scan the repository for consistency:
  - Every lesson has overview.md and assessment.md
  - `python3 scripts/build_site.py` succeeds
  - PLAN.md matches existing lessons
  - MEMORY.md has no contradictions

Output:
- A short report in Markdown
- A list of proposed fixes (do not apply unless asked)
