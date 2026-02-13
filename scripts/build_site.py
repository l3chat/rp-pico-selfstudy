#!/usr/bin/env python3
"""Generate a static learner site from lesson sources.

Usage:
  python3 scripts/build_site.py
"""

from __future__ import annotations

import re
import shutil
from pathlib import Path

try:
    import markdown
except ModuleNotFoundError as exc:
    raise SystemExit(
        "Missing dependency: markdown. Install with: python3 -m pip install markdown"
    ) from exc


ROOT = Path(__file__).resolve().parent.parent
LESSONS_DIR = ROOT / "lessons"
SITE_DIR = ROOT / "site"
SITE_LESSONS_DIR = SITE_DIR / "lessons"
LESSON_DIR_RE = re.compile(r"^L[0-9A-Z]+-.+")

CSS = """
:root {
  color-scheme: light;
  --bg: #f6f7fb;
  --surface: #ffffff;
  --text: #1f2430;
  --muted: #5b6375;
  --accent: #0d6efd;
  --border: #dde2ef;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: "Segoe UI", Tahoma, sans-serif;
  color: var(--text);
  background: radial-gradient(circle at 20% 0%, #e8eefc, var(--bg));
}
.wrap {
  max-width: 980px;
  margin: 0 auto;
  padding: 1.5rem 1rem 3rem;
}
header {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 1rem 1.25rem;
  margin-bottom: 1rem;
}
nav a {
  color: var(--accent);
  margin-right: 1rem;
  text-decoration: none;
  font-weight: 600;
}
article {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 1.25rem;
}
h1, h2, h3, h4 { line-height: 1.25; }
pre {
  background: #101522;
  color: #dbe7ff;
  padding: 0.85rem;
  border-radius: 8px;
  overflow-x: auto;
}
code {
  font-family: "Consolas", "SFMono-Regular", monospace;
}
ul, ol { padding-left: 1.35rem; }
a { color: var(--accent); }
.muted { color: var(--muted); }
"""


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def first_heading(markdown_text: str, fallback: str) -> str:
    for line in markdown_text.splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return fallback


def strip_leading_h1(markdown_text: str) -> str:
    lines = markdown_text.splitlines()
    idx = 0
    while idx < len(lines) and not lines[idx].strip():
        idx += 1
    if idx < len(lines) and lines[idx].startswith("# "):
        lines = lines[:idx] + lines[idx + 1 :]
    return "\n".join(lines).lstrip("\n")


def normalize_nested_list_indentation(markdown_text: str) -> str:
    """Adapt 2-space nested list authoring to Python-Markdown's parser behavior.

    Authoring rules in AGENTS.md use two-space nested lists. Python-Markdown
    often needs deeper indentation to keep nested items under their parent list.
    """
    out: list[str] = []
    in_fence = False
    list_item_re = re.compile(r"^( +)([-*+] |\d+\. )")

    for line in markdown_text.splitlines():
        if line.startswith("```"):
            in_fence = not in_fence
            out.append(line)
            continue

        if not in_fence:
            match = list_item_re.match(line)
            if match:
                leading_spaces = len(match.group(1))
                if leading_spaces >= 2:
                    line = (" " * (leading_spaces * 2)) + line[leading_spaces:]

        out.append(line)

    return "\n".join(out)


def normalize_indented_fenced_code_blocks(markdown_text: str) -> str:
    """Render list-indented fenced code blocks as nested indented code blocks.

    Python-Markdown does not reliably parse fenced code blocks nested in lists.
    This preserves readability for lesson steps with embedded commands.
    """
    lines = markdown_text.splitlines()
    out: list[str] = []
    idx = 0
    opening_re = re.compile(r"^( +)```([A-Za-z0-9_-]*)\s*$")

    while idx < len(lines):
        line = lines[idx]
        open_match = opening_re.match(line)
        if not open_match:
            out.append(line)
            idx += 1
            continue

        fence_indent = open_match.group(1)
        close_re = re.compile(rf"^{re.escape(fence_indent)}```\s*$")

        idx += 1
        code_lines: list[str] = []
        while idx < len(lines) and not close_re.match(lines[idx]):
            code_line = lines[idx]
            if code_line.startswith(fence_indent):
                code_line = code_line[len(fence_indent) :]
            code_lines.append(code_line)
            idx += 1

        if idx < len(lines):
            idx += 1

        # Indent enough to stay attached to the owning list item.
        code_indent = " " * (len(fence_indent) + 5)
        if out and out[-1] != "":
            out.append("")
        for code_line in code_lines:
            out.append(code_indent + code_line)
        out.append("")

    return "\n".join(out)


def merge_lesson_markdown(overview: str, assessment: str) -> str:
    overview_body = strip_leading_h1(overview).strip()
    assessment_body = strip_leading_h1(assessment).strip()
    return f"{overview_body}\n\n## Assessment\n\n{assessment_body}\n"


def md_to_html(markdown_text: str) -> str:
    normalized_md = normalize_nested_list_indentation(markdown_text)
    normalized_md = normalize_indented_fenced_code_blocks(normalized_md)
    return markdown.markdown(
        normalized_md,
        extensions=["fenced_code", "tables", "toc", "sane_lists"],
        output_format="html5",
    )


def render_page(title: str, body_html: str, asset_prefix: str = "") -> str:
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title}</title>
  <link rel="stylesheet" href="{asset_prefix}style.css">
</head>
<body>
  <div class="wrap">
    <header>
      <h1>{title}</h1>
      <nav>
        <a href="{asset_prefix}index.html">Home</a>
        <a href="{asset_prefix}syllabus.html">Syllabus</a>
      </nav>
    </header>
    <article>
      {body_html}
    </article>
  </div>
</body>
</html>
"""


def discover_lessons() -> list[Path]:
    if not LESSONS_DIR.exists():
        return []
    lesson_dirs = [
        path
        for path in LESSONS_DIR.iterdir()
        if path.is_dir() and LESSON_DIR_RE.match(path.name)
    ]
    return sorted(lesson_dirs, key=lambda path: path.name)


def write_site_files(lessons: list[tuple[str, str]]) -> None:
    lesson_links = "".join(
        f'<li><a href="lessons/{slug}.html">{title}</a></li>\n'
        for slug, title in lessons
    )
    index_body = (
        "<p class=\"muted\">Published from lesson sources by GitHub Actions.</p>\n"
        "<p>Start with the syllabus:</p>\n"
        "<ul><li><a href=\"syllabus.html\">Open Syllabus</a></li></ul>\n"
    )
    syllabus_body = (
        "<p>The following lessons were generated from <code>lessons/</code>:</p>\n"
        f"<ul>\n{lesson_links}</ul>\n"
    )
    (SITE_DIR / "style.css").write_text(CSS.strip() + "\n", encoding="utf-8")
    (SITE_DIR / "index.html").write_text(
        render_page("RP Pico Self-Study", index_body),
        encoding="utf-8",
    )
    (SITE_DIR / "syllabus.html").write_text(
        render_page("Syllabus", syllabus_body),
        encoding="utf-8",
    )


def main() -> int:
    lessons = discover_lessons()
    if SITE_DIR.exists():
        shutil.rmtree(SITE_DIR)
    SITE_LESSONS_DIR.mkdir(parents=True, exist_ok=True)

    lesson_rows: list[tuple[str, str]] = []
    for lesson_dir in lessons:
        overview_path = lesson_dir / "overview.md"
        assessment_path = lesson_dir / "assessment.md"
        if not overview_path.exists() or not assessment_path.exists():
            # Keep build going for partial repositories.
            continue

        overview_text = read_text(overview_path)
        assessment_text = read_text(assessment_path)
        merged_md = merge_lesson_markdown(overview_text, assessment_text)
        lesson_title = first_heading(overview_text, lesson_dir.name)
        lesson_html = md_to_html(merged_md)

        out_path = SITE_LESSONS_DIR / f"{lesson_dir.name}.html"
        out_path.write_text(
            render_page(lesson_title, lesson_html, asset_prefix="../"),
            encoding="utf-8",
        )
        lesson_rows.append((lesson_dir.name, lesson_title))

    write_site_files(lesson_rows)
    print(f"Generated site for {len(lesson_rows)} lessons at: {SITE_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
