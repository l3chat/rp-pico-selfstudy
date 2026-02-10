#!/usr/bin/env python3
"""Host environment checker for lesson L00.

Usage:
  python3 env_check.py
  python3 env_check.py --strict
"""

from __future__ import annotations

import argparse
import platform
import shutil
import subprocess
import sys
from typing import Iterable

TOOL_CHECKS = [
    {
        "name": "python3",
        "required": True,
        "version_cmd": [sys.executable, "--version"],
    },
    {
        "name": "git",
        "required": True,
        "version_cmd": ["git", "--version"],
    },
    {
        "name": "cmake",
        "required": True,
        "version_cmd": ["cmake", "--version"],
    },
    {
        "name": "arm-none-eabi-gcc",
        "required": True,
        "version_cmd": ["arm-none-eabi-gcc", "--version"],
    },
    {
        "name": "code",
        "required": False,
        "version_cmd": ["code", "--version"],
    },
    {
        "name": "ninja",
        "required": False,
        "version_cmd": ["ninja", "--version"],
    },
    {
        "name": "mpremote",
        "required": False,
        "version_cmd": ["mpremote", "--version"],
    },
    {
        "name": "picotool",
        "required": False,
        "version_cmd": ["picotool", "version"],
    },
]


def first_line(lines: Iterable[str]) -> str:
    for line in lines:
        cleaned = line.strip()
        if cleaned:
            return cleaned
    return "(no output)"


def command_preview(name: str, version_cmd: list[str]) -> str:
    if name == "python3":
        return " ".join(version_cmd)
    return name


def run_version(version_cmd: list[str]) -> tuple[bool, str]:
    try:
        completed = subprocess.run(
            version_cmd,
            capture_output=True,
            text=True,
            timeout=5,
            check=False,
        )
    except Exception as exc:  # pragma: no cover - best effort diagnostics
        return False, f"error running version command: {exc}"

    output = first_line((completed.stdout or "").splitlines())
    if output == "(no output)":
        output = first_line((completed.stderr or "").splitlines())
    if completed.returncode != 0:
        return False, output
    return True, output


def check_tool(name: str, required: bool, version_cmd: list[str]) -> tuple[str, str]:
    cmd = command_preview(name, version_cmd)

    if name == "python3":
        found = True
    else:
        found = shutil.which(name) is not None

    if not found:
        return "MISSING", f"{cmd} not found in PATH"

    ok, info = run_version(version_cmd)
    if ok:
        return "OK", info
    return "ERROR", info


def main() -> int:
    parser = argparse.ArgumentParser(description="Check toolchain for L00")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Exit with status 1 when required tools are missing or broken.",
    )
    args = parser.parse_args()

    print("L00 environment check")
    print(f"Platform: {platform.platform()}")
    print(f"Python: {sys.version.split()[0]}")
    print()

    missing_required = []

    for item in TOOL_CHECKS:
        status, detail = check_tool(item["name"], item["required"], item["version_cmd"])
        required_label = "required" if item["required"] else "optional"
        print(f"[{status:<7}] {item['name']:<18} ({required_label}) {detail}")

        if item["required"] and status != "OK":
            missing_required.append(item["name"])

    print()
    if missing_required:
        print("Required tools that still need attention:")
        for name in missing_required:
            print(f"- {name}")
        if args.strict:
            return 1
    else:
        print("All required tools look ready.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
