#!/usr/bin/env python3
"""Check local tool availability for the L00 environment lesson.

Usage:
  python3 lessons/L00-vscode-env/code/verify_env.py
  python3 lessons/L00-vscode-env/code/verify_env.py --strict
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
from dataclasses import dataclass


@dataclass(frozen=True)
class Tool:
    command: str
    label: str
    required: bool


TOOLS: list[Tool] = [
    Tool("git", "Git", True),
    Tool("python3", "Python 3", True),
    Tool("cmake", "CMake", True),
    Tool("ninja", "Ninja", False),
    Tool("arm-none-eabi-gcc", "ARM GCC toolchain", False),
    Tool("picotool", "picotool", False),
    Tool("mpremote", "mpremote", False),
]


def tool_version(command: str) -> str:
    """Return a short version line when available."""
    version_args = {
        "python3": ["--version"],
        "arm-none-eabi-gcc": ["--version"],
        "git": ["--version"],
        "cmake": ["--version"],
        "ninja": ["--version"],
        "picotool": ["version"],
        "mpremote": ["--version"],
    }
    args = [command] + version_args.get(command, ["--version"])
    try:
        proc = subprocess.run(
            args,
            capture_output=True,
            text=True,
            check=False,
        )
    except OSError:
        return ""

    output = (proc.stdout or proc.stderr).strip().splitlines()
    return output[0].strip() if output else ""


def main() -> int:
    parser = argparse.ArgumentParser(description="Check environment tools for L00")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Return non-zero exit code when any required tool is missing.",
    )
    args = parser.parse_args()

    found_required = 0
    missing_required: list[Tool] = []
    missing_optional: list[Tool] = []

    print("L00 environment check")
    print("=" * 72)
    print(f"{'Tool':24} {'Required':8} {'Status':8} Details")
    print("-" * 72)

    for tool in TOOLS:
        path = shutil.which(tool.command)
        required = "yes" if tool.required else "no"
        if path:
            status = "FOUND"
            details = tool_version(tool.command)
            details = f"{path} | {details}" if details else path
            if tool.required:
                found_required += 1
        else:
            status = "MISSING"
            details = "install needed"
            if tool.required:
                missing_required.append(tool)
            else:
                missing_optional.append(tool)

        print(f"{tool.label:24} {required:8} {status:8} {details}")

    print("=" * 72)
    print(f"Required tools found: {found_required}/3")

    if missing_required:
        print("Missing required tools:")
        for tool in missing_required:
            print(f"- {tool.label} ({tool.command})")
    else:
        print("All required tools are present.")

    if missing_optional:
        print("Missing recommended tools (can be installed later):")
        for tool in missing_optional:
            print(f"- {tool.label} ({tool.command})")

    if args.strict and missing_required:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
