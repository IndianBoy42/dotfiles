# opencode Agent Definition Guide

Agent definitions in opencode are Markdown files with YAML frontmatter that define AI agents with specific behaviors and capabilities. Agents are automatically loaded from `.opencode/agent/**/*.md` or `~/.config/opencode/agent/**/*.md`.

## File Structure

```markdown
---
name: agent-name
model: provider/model-id
description: What this agent does
mode: subagent
hidden: true
permission:
  "*": deny
  edit: allow
  bash: ask
---

Your agent's instructions go here. This is the system prompt that defines behavior.
```

## Frontmatter Fields

### Required Fields

None are strictly required, but at minimum you should define:

- **`description`** (string): What this agent does and when to use it. This is displayed in the UI and helps users understand the agent's purpose.

### Agent Mode

- **`mode`** (string): Determines when the agent is active
  - `"subagent"`: Only callable via `@agent-name` or selected from @ menu
  - `"primary"`: Only appears in main mode selector (for specific tasks like PR handling)
  - `"all"` (default): Available both as primary and subagent

### Visibility

- **`hidden`** (boolean): When `true`, hides the agent from `@` autocomplete menu. Useful for primary agents that shouldn't be manually invoked. Only affects subagent visibility.

### Model Configuration

- **`model`** (string): Model in `provider/model-id` format (e.g., `opencode/claude-sonnet-4`, `anthropic/claude-3-5-sonnet-latest`, `openai/gpt-4o`)
- **`variant`** (string): Model variant for reasoning models
- **`temperature`** (number): 0.0-1.0, controls creativity vs determinism
- **`top_p`** (number): 0.0-1.0, nucleus sampling parameter

### Tool Permissions (Permission Field)

The `permission` field controls what tools the agent can use and how it uses them. Three permission levels:

- **`allow`**: Agent can use the tool without asking
- **`ask`**: Agent asks for user confirmation before using the tool
- **`deny`**: Agent cannot use the tool at all

#### Available Permissions

```yaml
permission:
  # Wildcard - disables ALL tools by default
  "*": deny

  # File operations
  read: allow # Read file contents
  edit: allow # Write/edit files (includes write, patch, multiedit)
  list: ask # List directory contents
  glob: allow # Search files by glob patterns
  grep: allow # Search file contents by pattern

  # Execution
  bash: ask # Run terminal commands (ask = requires approval)
  task: ask # Spawn subagents (subagent creation)

  # Web & Search
  webfetch: allow # Fetch web pages
  websearch: allow # Search the web
  codesearch: allow # Search code APIs/libraries

  # LSP & Code Intelligence
  lsp: ask # Language server protocol (format, definitions, etc.)

  # Workflow
  todowrite: allow # Create/update todo lists
  todoread: allow # Read todo lists

  # User Interaction
  question: allow # Ask the user questions

  # Advanced
  skill: allow # Load and use skills
  external_directory: ask # Access external project directories
  doom_loop: allow # Detect repetitive tool usage patterns
```

#### Permission Patterns

**1. Wildcard with specific overrides (recommended):**

```yaml
permission:
  "*": deny # Disable everything by default
  read: allow # Enable specific tools
  edit: allow
  glob: allow
  grep: allow
  bash: ask # Require approval for shell commands
```

**2. Granular per-tool permission:**

```yaml
permission:
  bash: deny # No terminal access
  edit: # Edit permission with extra control
    "*": allow # Allow editing by default
    "*.js": ask # Ask before editing JS files
    "*.config.ts": deny # Never edit config files
```

**3. All tools allowed (for trusted agents):**

```yaml
permission: allow
```

**4. All tools require approval (safe default):**

```yaml
permission: ask
```

#### Common Patterns by Agent Type

**Read-only agent (documentation helper):**

```yaml
permission:
  "*": deny
  read: allow
  glob: allow
  grep: allow
  webfetch: allow
  websearch: allow
  codesearch: allow
```

**Safe coding agent (requires approval for writes/execution):**

```yaml
permission:
  "*": ask # Ask for everything by default
  read: allow
  glob: allow
  grep: allow
  list: allow
  todowrite: allow
  todoread: allow
```

**Restricted subagent (file-specific):**

```yaml
permission:
  edit:
    "*": deny
    "src/**/*.ts": ask # Can edit TS files with approval
    "tests/**/*.ts": allow # Can freely edit test files
  bash: deny
```

### Legacy Tools Field (Deprecated)

```yaml
tools:
  "*": false
  "edit": true
  "bash": true
```

**Migration to permission field:**

| Old tools syntax | New permission syntax |
| ---------------- | --------------------- |
| `"*": false`     | `"*": deny`           |
| `"*": true`      | `"*": allow`          |
| `"edit": true`   | `edit: allow`         |
| `"edit": false`  | `edit: deny`          |

### Appearance

- **`color`** (string): Visual identifier
  - Hex: `#E67E22`, `#3498db`
  - Theme colors: `primary`, `secondary`, `accent`, `success`, `warning`, `error`, `info`

### Lifecycle Control

- **`disable`** (boolean): When `true`, completely disables the agent
- **`steps`** (number): Maximum agentic iterations (deprecated: `maxSteps`)

### Provider-Specific Options

- **`options`** (object): Provider-specific settings passed to the model
  ```yaml
  options:
    reasoningEffort: high
    textVerbosity: verbose
  ```

### Alternative: Prompt in Frontmatter

Instead of writing content after `---`, you can include the prompt inline:

```yaml
prompt: "You are a specialized agent for..."
```

## Complete Example

```markdown
---
name: security-audit
description: Security-focused agent for auditing code for vulnerabilities
mode: subagent
hidden: false
color: error
model: opencode/claude-sonnet-4
temperature: 0.1
permission:
  "*": deny
  read: allow
  glob: allow
  grep: allow
  codesearch: allow
  bash: ask
---

You are a security auditor specialized in finding vulnerabilities in code.
Focus on:

- Injection vulnerabilities (SQL, command, code)
- Authentication and authorization flaws
- Data exposure risks
- Cryptographic weaknesses

When you find issues, provide clear explanations and remediation steps.
Never make changes without user approval.
```

## Best Practices

1. **Least privilege**: Start with `"*": deny` and enable only what you need
2. **Approval for dangerous ops**: Use `ask` for `edit` and `bash` unless fully trusted
3. **Descriptive descriptions**: Help users understand when to invoke your agent
4. **Use mode appropriately**: Use `subagent` for helpers, `primary` for task-specific agents
5. **Prefer permission over tools**: The `permission` field is more flexible than the deprecated `tools` field
6. **Wildcard ordering**: Place `"*"` first, then specific permissions (order matters for overrides)
