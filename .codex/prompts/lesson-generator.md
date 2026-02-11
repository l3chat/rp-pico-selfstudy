# Codex Prompt Template: Generate a Lesson

You are working inside this repo. Follow AGENTS.md strictly.

Task:
- Create a new lesson directory under /lessons named:
  /lessons/<LESSON_ID>-<short-slug>/

Inside it create:
- overview.md (90-minute structure, checklists, expected results)
- assessment.md (quiz + practical task + rubric)
- code/ directory with minimal runnable examples

Update:
- PLAN.md: mark the lesson as ☐ in progress (or ☑ done if fully complete)
- MEMORY.md: record any decisions or discovered pitfalls
- Ensure site generation still works by running:
  - `python3 scripts/build_site.py`
