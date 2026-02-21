---
name: justfile-creation
description: "Use when creating Justfiles, needing modern command runners, or implementing just command runner patterns for task automation."
---

# Justfile Creation

Guide for creating Justfiles using the just command runner.

## Overview

Just is a modern command runner inspired by Make but simpler. It doesn't track file dependencies - it just runs commands. This makes it ideal for task automation without the complexity of Make.

## When to Use

- Creating task runners for common operations
- Need a modern alternative to Make for non-build tasks
- Want easy argument passing to recipes
- Need cross-platform shell support
- Want simpler syntax than Make

## Basic Template

```justfile
# Project Configuration
project := "myproject"
version := "1.0.0"

# Default recipe (runs when no recipe specified)
default: list

# List all available recipes
list:
    @just --list

# Show help
help:
    @echo "Available recipes:"
    @just --list

# Development recipes
build:
    echo "Building {{project}}..."
    # Build commands here

test:
    echo "Running tests..."
    # Test commands here

lint:
    echo "Running linter..."
    # Lint commands here

format:
    echo "Formatting code..."
    # Format commands here

clean:
    echo "Cleaning build artifacts..."
    rm -rf build/

# Installation
install:
    echo "Installing {{project}}..."
    # Installation commands
```

## Key Concepts

### Variables
```justfile
name := "myproject"
version := "1.0.0"

# Use variables with {{}}
build:
    echo "Building {{name}} v{{version}}"
```

### Recipes (Commands)
```justfile
# Simple recipe
hello:
    echo "Hello, World!"

# Recipe with arguments
greet name:
    echo "Hello, {{name}}!"

# Recipe with default argument
greet name="World":
    echo "Hello, {{name}}!"
```

### Dependencies
```justfile
# Recipe that depends on another
build: clean
    echo "Building..."

# Multiple dependencies
deploy: build test
    echo "Deploying..."
```

## Common Patterns

### Help System
```justfile
# List all recipes as default
default:
    @just --list

# Or with custom formatting
help:
    @echo "Available recipes:"
    @just --list --unsorted
```

### Environment Setup
```justfile
# Check for required tools
check-tools:
    #!/usr/bin/env bash
    command -v docker >/dev/null 2>&1 || { echo "docker required"; exit 1; }
    command -v node >/dev/null 2>&1 || { echo "node required"; exit 1; }

# Setup development environment
setup: check-tools
    npm install
    echo "Setup complete"
```

### Error Handling
```justfile
# Fail on error (just does this by default)
dangerous:
    set -e
    rm -rf /important/path  # Will stop if this fails
    echo "Done"

# Continue on error
lenient:
    -rm nonexistent.txt  # The dash means ignore errors
    echo "Done"
```

### Conditional Logic
```justfile
# Check if file exists
backup file:
    #!/usr/bin/env bash
    if [[ -f "{{file}}" ]]; then
        cp "{{file}" "{{file}}.bak"
        echo "Backup created"
    else
        echo "File not found: {{file}}"
        exit 1
    fi
```

### Platform-Specific
```justfile
# Detect OS
os := `uname -s`

# Platform-specific build
build:
    #!/usr/bin/env bash
    if [[ "{{os}}" == "Darwin" ]]; then
        echo "Building for macOS..."
    else
        echo "Building for Linux..."
    fi
```

## Best Practices

1. **Use `default` recipe** - Always define what runs by default
2. **Provide `list` or `help`** - Make recipes discoverable
3. **Use variables** for paths, names, and configuration
4. **Add comments** with `#` to document recipes
5. **Use `set -e`** for bash scripts to fail fast
6. **Prefix with `@`** to suppress echoing of the command
7. **Use dependencies** to chain operations
8. **Use arguments** to make recipes flexible

## Advanced Features

### Shebang Scripts
```justfile
complex-task:
    #!/usr/bin/env python3
    import os
    print(f"Current directory: {os.getcwd()}")
    print("Running Python code in just!")
```

### Aliases
```justfile
alias b := build
alias t := test

build:
    echo "Building..."

test:
    echo "Testing..."
```

### Settings
```justfile
# Set shell for all recipes
set shell := ["bash", "-cu"]

# Allow positional arguments
set positional-arguments := true

# Export variables to environment
set export := true
```

### Dotenv Integration
```justfile
# Load .env file automatically
set dotenv-load := true

# Or load specific file
set dotenv-load := "production.env"

deploy:
    echo "Deploying to {{env_var('DEPLOY_HOST')}}"
```

## Examples

### Node.js Project
```justfile
# Node.js project tasks
node_version := "18"

default:
    @just --list

install:
    npm ci

dev:
    npm run dev

build:
    npm run build

test:
    npm test

lint:
    npm run lint

format:
    npm run format

clean:
    rm -rf node_modules dist/

docker-build:
    docker build -t myapp:{{node_version}} .
```

### Rust Project
```justfile
# Rust project tasks
default:
    @just --list

build:
    cargo build --release

test:
    cargo test

check:
    cargo check

fmt:
    cargo fmt

clippy:
    cargo clippy -- -D warnings

clean:
    cargo clean

doc:
    cargo doc --open

# Run with features
run *args:
    cargo run --features "dev" {{args}}
```

### Documentation Site
```justfile
# Documentation with MkDocs
default:
    @just --list

serve:
    mkdocs serve

build:
    mkdocs build

deploy: build
    mkdocs gh-deploy

clean:
    rm -rf site/

# Update dependencies
update:
    pip install -U mkdocs mkdocs-material
```
