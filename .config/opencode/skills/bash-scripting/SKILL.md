---
name: bash-scripting
description: "Use when creating or modifying bash shell scripts, needing script templates, error handling patterns, or shell scripting best practices."
---

# Bash Scripting

Comprehensive guide for writing robust, maintainable bash scripts.

## Overview

Bash is the standard shell on most Linux and macOS systems. This skill provides templates, patterns, and best practices for creating production-ready shell scripts.

## When to Use

- Creating automation scripts
- Writing build/deployment scripts
- Need error handling patterns
- Want script structure templates
- Need to handle arguments and options

## Script Template

### Minimal Safe Script
```bash
#!/bin/bash
set -euo pipefail

main() {
    echo "Hello, World!"
}

main "$@"
```

### Production-Ready Script
```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"

# Error handling
trap 'echo "Error on line $LINENO" >&2; exit 1' ERR
trap 'echo "Interrupted" >&2; exit 130' INT

# Usage information
usage() {
    cat << EOF
Usage: ${SCRIPT_NAME} [OPTIONS] [ARGUMENTS]

Options:
  -h, --help        Show this help message
  -v, --verbose     Enable verbose output
  -d, --dry-run     Show what would be done without executing

Examples:
  ${SCRIPT_NAME} --verbose
  ${SCRIPT_NAME} --dry-run
EOF
}

# Parse arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=1
                shift
                ;;
            *)
                echo "Unknown option: $1" >&2
                usage >&2
                exit 1
                ;;
        esac
    done
}

# Logging functions
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log_verbose() {
    [[ ${VERBOSE:-0} -eq 1 ]] && log "$@"
}

log_error() {
    log "ERROR: $*" >&2
}

# Main logic
main() {
    parse_args "$@"
    
    log_verbose "Starting script..."
    
    # Your logic here
    
    log "Script completed successfully"
}

main "$@"
```

## Error Handling

### Strict Mode Options
```bash
set -e          # Exit on error
set -u          # Error on undefined variables
set -o pipefail # Catch errors in pipelines
set -euo pipefail  # All three combined
```

### Traps
```bash
# Catch errors
trap 'echo "Error on line $LINENO" >&2' ERR

# Cleanup on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# Handle signals
trap 'echo "Interrupted"; exit 130' INT TERM
```

## Variable Best Practices

### Quoting
```bash
# CORRECT - Always quote variables
file="${1:-default.txt}"
cat "${file}"

# WRONG - Unquoted variables break on spaces
cat ${file}  # Fails if file="my file.txt"
```

### Default Values
```bash
name="${1:-default}"      # Use default if unset/null
name="${1:?required}"     # Error if unset/null
name="${1:=default}"      # Assign default if unset
readonly name="${1}"      # Make read-only
```

## Common Patterns

### Check if Command Exists
```bash
if command -v git >/dev/null 2>&1; then
    echo "Git is installed"
fi
```

### Check if File Exists
```bash
if [[ -f "$file" ]]; then
    echo "File exists"
fi

if [[ -d "$dir" ]]; then
    echo "Directory exists"
fi
```

### Iterate Over Files
```bash
for file in *.txt; do
    [[ -f "$file" ]] || continue  # Skip if no match
    process "$file"
done
```

### Read File Line by Line
```bash
while IFS= read -r line; do
    echo "$line"
done < "file.txt"
```

### Process Options
```bash
while getopts "hvd:" opt; do
    case $opt in
        h) usage; exit 0 ;;
        v) VERBOSE=1 ;;
        d) DIR="$OPTARG" ;;
        ?) usage >&2; exit 1 ;;
    esac
done
shift $((OPTIND-1))
```

## Safety Patterns

### Dry Run Mode
```bash
run() {
    if [[ ${DRY_RUN:-0} -eq 1 ]]; then
        echo "[DRY RUN] Would execute: $*"
    else
        "$@"
    fi
}

run rm -rf "${dir}"
```

### Confirm Destructive Actions
```bash
confirm() {
    read -r -p "Are you sure? [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}

if confirm; then
    rm -rf "$dir"
fi
```

### Safe Temporary Files
```bash
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
```

## Debugging

### Verbose Mode
```bash
[[ ${VERBOSE:-0} -eq 1 ]] && set -x  # Trace execution
```

### Debug Output
```bash
debug() {
    [[ ${DEBUG:-0} -eq 1 ]] && echo "DEBUG: $*" >&2
}
```

## Examples

### Backup Script
```bash
#!/bin/bash
set -euo pipefail

SOURCE="${1:-.}"
DEST="${2:-backup}"
timestamp=$(date +%Y%m%d_%H%M%S)

mkdir -p "$DEST"
tar -czf "${DEST}/backup_${timestamp}.tar.gz" "$SOURCE"
echo "Backup created: ${DEST}/backup_${timestamp}.tar.gz"
```

### Parallel Processing
```bash
#!/bin/bash
set -euo pipefail

process_file() {
    local file="$1"
    # Process logic here
    echo "Processed: $file"
}

export -f process_file

find . -name "*.txt" -print0 | xargs -0 -P4 -I{} bash -c 'process_file "$@"' _ {}
```
