#!/usr/bin/env python3
import os
import subprocess
import sys

# Configuration
MARKER_FILE = ".yadmtrack"
YADM_CMD = ["yadm"]


def get_tracked_markers():
    """
    Ask yadm for a list of all files named .yadmtrack that are currently
    in the index (tracked).
    """
    try:
        # git ls-files returns paths relative to the repo root (HOME)
        result = subprocess.run(
            YADM_CMD + ["ls-files", f"*/{MARKER_FILE}"],
            capture_output=True,
            text=True,
            check=True,
        )

        files = result.stdout.strip().split("\n")

        return [f for f in files if f]  # Filter empty strings
    except subprocess.CalledProcessError as e:
        print(f"Error listing tracked markers: {e}", file=sys.stderr)
        return []


def add_directory_contents(marker_path):
    """
    Given the path to a marker file (e.g., .config/nvim/.yadmtrack),
    add the containing directory to yadm.
    """
    # Get the directory containing the marker
    directory = os.path.dirname(marker_path)

    if not directory:
        directory = "."  # Handle root directory

    # We want to add everything in this directory.
    # yadm add -u (update) only stages modified tracked files.
    # yadm add <dir> stages new files and modified files.
    # We use '.' to refer to the directory relative to CWD (which is HOME for yadm hooks)

    full_path = os.path.join(os.environ.get("HOME"), directory)

    if not os.path.isdir(full_path):
        return

    print(f"Auto-tracking contents of: {directory}")

    try:
        # We explicitly add the directory.
        # This respects .gitignore automatically.
        subprocess.run(
            YADM_CMD + ["add", directory],
            check=True,
            stdout=subprocess.DEVNULL,  # Keep it quiet usually
            stderr=subprocess.PIPE,
        )
    except subprocess.CalledProcessError as e:
        # Ignore errors (like if the directory is empty or fully ignored)
        pass


def main():
    # Ensure we are running from HOME, as yadm hooks usually do,
    # but let's be safe.
    os.chdir(os.environ.get("HOME"))

    markers = get_tracked_markers()

    if not markers:
        return

    print(f"yadm-track: Scanning {len(markers)} directories with {MARKER_FILE}...")

    for marker in markers:
        add_directory_contents(marker)


if __name__ == "__main__":
    main()
