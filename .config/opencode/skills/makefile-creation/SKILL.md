---
name: makefile-creation
description: "Use when creating Makefiles, needing build automation, defining make targets, or implementing standard makefile patterns and recipes."
---

# Makefile Creation

Guide for creating effective Makefiles for build automation and task running.

## Overview

Make is a powerful build automation tool that tracks file dependencies. This skill provides templates and best practices for creating maintainable Makefiles.

## When to Use

- Building software projects
- Managing complex build dependencies
- Creating task runners for common operations
- Need file-based dependency tracking
- Want incremental builds (only rebuild changed files)

## Basic Template

```makefile
# Project Configuration
PROJECT_NAME := myproject
VERSION := 1.0.0

# Directories
BUILD_DIR := build
SRC_DIR := src
TEST_DIR := tests

# Tools
CC := gcc
CFLAGS := -Wall -Wextra -O2
LDFLAGS :=

# Files
SOURCES := $(wildcard $(SRC_DIR)/*.c)
OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SOURCES))

# Phony targets (not actual files)
.PHONY: all clean build test install help

# Default target
.DEFAULT_GOAL := help

# Help target (displays available commands)
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Build targets
all: build ## Build the entire project

build: $(BUILD_DIR) $(OBJECTS) ## Build project
	@echo "Building $(PROJECT_NAME)..."
	$(CC) $(OBJECTS) -o $(BUILD_DIR)/$(PROJECT_NAME) $(LDFLAGS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Test targets
test: build ## Run tests
	@echo "Running tests..."
	$(TEST_DIR)/run_tests.sh

# Clean target
clean: ## Remove build artifacts
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)

# Install target
install: build ## Install the project
	@echo "Installing $(PROJECT_NAME)..."
	cp $(BUILD_DIR)/$(PROJECT_NAME) /usr/local/bin/
```

## Key Concepts

### Phony Targets
```makefile
.PHONY: clean build test
```
Mark targets that don't produce files to prevent conflicts with actual files.

### Automatic Variables
| Variable | Meaning |
|----------|---------|
| `$@` | Target name |
| `$<` | First prerequisite |
| `$^` | All prerequisites |
| `$?` | Prerequisites newer than target |
| `$*` | Stem of pattern rule |

### Pattern Rules
```makefile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
```

## Common Patterns

### Help System
```makefile
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Usage: make target  ## Description
```

### Environment Detection
```makefile
# Detect OS
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    CFLAGS += -DMACOS
endif
ifeq ($(UNAME_S),Linux)
    CFLAGS += -DLINUX
endif

# Detect if running in CI
ifdef CI
    FLAGS += --ci
endif
```

### Conditional Logic
```makefile
# Check if variable is set
ifdef DEBUG
    CFLAGS += -g -DDEBUG
else
    CFLAGS += -O2
endif

# Check if file exists
ifneq (,$(wildcard .env))
    include .env
    export
endif
```

### Recursive Make
```makefile
subdirs := foo bar baz

$(subdirs):
	$(MAKE) -C $@

.PHONY: all $(subdirs)
all: $(subdirs)
```

## Best Practices

1. **Use .PHONY** for all targets that don't create files
2. **Provide a help target** for self-documentation
3. **Use variables** for paths, flags, and tool names
4. **Add comments** with `##` to document targets
5. **Use automatic variables** (`$@`, `$<`, `$^`) for cleaner rules
6. **Create directories** before writing to them
7. **Clean targets** should remove all generated files

## Examples

### Python Project
```makefile
.PHONY: install test lint format clean help

VENV := .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

$(VENV)/bin/activate: requirements.txt
	python -m venv $(VENV)
	$(PIP) install -r requirements.txt

install: $(VENV)/bin/activate ## Install dependencies

lint: $(VENV)/bin/activate ## Run linter
	$(PYTHON) -m flake8 src/

format: $(VENV)/bin/activate ## Format code
	$(PYTHON) -m black src/ tests/

test: $(VENV)/bin/activate ## Run tests
	$(PYTHON) -m pytest tests/

clean: ## Remove build artifacts
	rm -rf $(VENV) .pytest_cache __pycache__
```

### Documentation Site
```makefile
.PHONY: serve build deploy clean help

DOCS_DIR := docs
BUILD_DIR := site

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

serve: ## Start development server
	cd $(DOCS_DIR) && mkdocs serve

build: ## Build documentation
	cd $(DOCS_DIR) && mkdocs build -d ../$(BUILD_DIR)

deploy: build ## Deploy to production
	cd $(BUILD_DIR) && rsync -avz . user@server:/var/www/docs/

clean: ## Clean build files
	rm -rf $(BUILD_DIR)
```
