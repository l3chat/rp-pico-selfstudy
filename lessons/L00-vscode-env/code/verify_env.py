#!/usr/bin/env python3
"""Check local tool availability for the L00 environment lesson.

Usage:
  python3 lessons/L00-vscode-env/code/verify_env.py
  python3 lessons/L00-vscode-env/code/verify_env.py --strict
  python3 lessons/L00-vscode-env/code/verify_env.py --strict-all
"""

from __future__ import annotations

import argparse
import importlib.metadata
import importlib.util
import os
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class CommandCheck:
    command: str
    label: str
    required: bool


@dataclass(frozen=True)
class PackageCheck:
    distribution: str
    import_name: str
    label: str
    required: bool


@dataclass(frozen=True)
class EnvPathCheck:
    env_var: str
    label: str
    required: bool
    must_contain: str | None = None


@dataclass(frozen=True)
class VscodeExtensionCheck:
    extension_id: str
    label: str
    required: bool


@dataclass(frozen=True)
class CheckResult:
    label: str
    kind: str
    required: bool
    status: str
    details: str


COMMAND_CHECKS: list[CommandCheck] = [
    CommandCheck("git", "Git", True),
    CommandCheck("python3", "Python 3", True),
    CommandCheck("cmake", "CMake", True),
    CommandCheck("ninja", "Ninja", False),
    CommandCheck("arm-none-eabi-gcc", "ARM GCC toolchain", False),
    CommandCheck("picotool", "picotool", False),
    CommandCheck("mpremote", "mpremote (command)", False),
    CommandCheck("code", "VS Code CLI (code)", False),
]

PACKAGE_CHECKS: list[PackageCheck] = [
    PackageCheck("pyserial", "serial", "pyserial (Python package)", False),
    PackageCheck("mpremote", "mpremote", "mpremote (Python package)", False),
]

ENV_PATH_CHECKS: list[EnvPathCheck] = [
    EnvPathCheck(
        "PICO_SDK_PATH",
        "pico-sdk path (PICO_SDK_PATH)",
        False,
        "external/pico_sdk_import.cmake",
    ),
]

VSCODE_EXTENSION_CHECKS: list[VscodeExtensionCheck] = [
    VscodeExtensionCheck("ms-python.python", "VS Code extension: ms-python.python", False),
    VscodeExtensionCheck("ms-vscode.cpptools", "VS Code extension: ms-vscode.cpptools", False),
    VscodeExtensionCheck(
        "ms-vscode.cmake-tools",
        "VS Code extension: ms-vscode.cmake-tools",
        False,
    ),
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
        "code": ["--version"],
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


def check_command(check: CommandCheck) -> CheckResult:
    path = shutil.which(check.command)
    if not path:
        return CheckResult(
            label=check.label,
            kind="command",
            required=check.required,
            status="MISSING",
            details="install needed",
        )

    version = tool_version(check.command)
    details = f"{path} | {version}" if version else path
    return CheckResult(
        label=check.label,
        kind="command",
        required=check.required,
        status="FOUND",
        details=details,
    )


def check_package(check: PackageCheck) -> CheckResult:
    spec = importlib.util.find_spec(check.import_name)
    if spec is None:
        return CheckResult(
            label=check.label,
            kind="package",
            required=check.required,
            status="MISSING",
            details=f"install needed: python3 -m pip install {check.distribution}",
        )

    try:
        version = importlib.metadata.version(check.distribution)
    except importlib.metadata.PackageNotFoundError:
        version = ""

    details = f"{check.distribution} {version}" if version else check.distribution
    return CheckResult(
        label=check.label,
        kind="package",
        required=check.required,
        status="FOUND",
        details=details,
    )


def check_env_path(check: EnvPathCheck) -> CheckResult:
    value = os.environ.get(check.env_var, "").strip()
    if not value:
        return CheckResult(
            label=check.label,
            kind="env-path",
            required=check.required,
            status="MISSING",
            details=f"{check.env_var} is not set",
        )

    root = Path(value).expanduser()
    if not root.exists():
        return CheckResult(
            label=check.label,
            kind="env-path",
            required=check.required,
            status="MISSING",
            details=f"{check.env_var} points to missing path: {root}",
        )

    if check.must_contain:
        required_path = root / check.must_contain
        if not required_path.exists():
            return CheckResult(
                label=check.label,
                kind="env-path",
                required=check.required,
                status="MISSING",
                details=f"path exists but missing {check.must_contain}",
            )

    return CheckResult(
        label=check.label,
        kind="env-path",
        required=check.required,
        status="FOUND",
        details=str(root),
    )


def read_vscode_extensions() -> tuple[set[str] | None, str]:
    code_path = shutil.which("code")
    if not code_path:
        return None, "`code` CLI not found in PATH"

    proc = subprocess.run(
        ["code", "--list-extensions"],
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        message = (proc.stderr or proc.stdout).strip().splitlines()
        detail = message[0] if message else "failed to list extensions"
        return None, f"`code --list-extensions` failed: {detail}"

    extensions = {
        line.strip().lower()
        for line in (proc.stdout or "").splitlines()
        if line.strip()
    }
    return extensions, ""


def check_vscode_extension(
    check: VscodeExtensionCheck,
    installed_extensions: set[str] | None,
    skip_reason: str,
) -> CheckResult:
    if installed_extensions is None:
        return CheckResult(
            label=check.label,
            kind="vscode-ext",
            required=check.required,
            status="SKIPPED",
            details=skip_reason,
        )

    if check.extension_id.lower() in installed_extensions:
        return CheckResult(
            label=check.label,
            kind="vscode-ext",
            required=check.required,
            status="FOUND",
            details=check.extension_id,
        )

    return CheckResult(
        label=check.label,
        kind="vscode-ext",
        required=check.required,
        status="MISSING",
        details=f"install extension ID: {check.extension_id}",
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Check environment tools for L00")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Return non-zero exit code when any required tool is missing.",
    )
    parser.add_argument(
        "--strict-all",
        action="store_true",
        help="Return non-zero exit code when any required or recommended check is missing.",
    )
    args = parser.parse_args()

    results: list[CheckResult] = []

    for check in COMMAND_CHECKS:
        results.append(check_command(check))

    for check in PACKAGE_CHECKS:
        results.append(check_package(check))

    for check in ENV_PATH_CHECKS:
        results.append(check_env_path(check))

    installed_extensions, skip_reason = read_vscode_extensions()
    for check in VSCODE_EXTENSION_CHECKS:
        results.append(check_vscode_extension(check, installed_extensions, skip_reason))

    required_total = sum(1 for result in results if result.required)
    found_required = sum(
        1 for result in results if result.required and result.status == "FOUND"
    )

    print("L00 environment check")
    print(f"Python interpreter for package checks: {sys.executable}")
    print("=" * 112)
    print(f"{'Item':36} {'Type':12} {'Required':8} {'Status':8} Details")
    print("-" * 112)

    for result in results:
        required = "yes" if result.required else "no"
        print(
            f"{result.label:36} {result.kind:12} {required:8} "
            f"{result.status:8} {result.details}"
        )

    missing_required = [
        result for result in results if result.required and result.status != "FOUND"
    ]
    missing_recommended = [
        result
        for result in results
        if (not result.required) and result.status in {"MISSING", "ERROR"}
    ]
    skipped_checks = [result for result in results if result.status == "SKIPPED"]

    print("=" * 112)
    print(f"Required checks found: {found_required}/{required_total}")

    if missing_required:
        print("Missing required tools:")
        for result in missing_required:
            print(f"- {result.label}: {result.details}")
    else:
        print("All required tools are present.")

    if missing_recommended:
        print("Missing recommended checks (can be completed later):")
        for result in missing_recommended:
            print(f"- {result.label}: {result.details}")

    if skipped_checks:
        print("Skipped checks:")
        for result in skipped_checks:
            print(f"- {result.label}: {result.details}")

    if args.strict and missing_required:
        return 1
    if args.strict_all and (missing_required or missing_recommended):
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
