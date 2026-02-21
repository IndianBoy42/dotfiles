---
name: kitty-terminal
description: "Use when you need detailed kitty terminal API reference, remote control commands, window management, or advanced kitty integration patterns."
---

# Kitty Terminal Integration

Complete reference for kitty terminal emulator remote control capabilities.

## Overview

Kitty is a GPU-based terminal emulator with extensive remote control features. This skill provides the complete API reference for creating windows, tabs, and managing terminal sessions programmatically.

## When to Use

- Need to launch commands in new kitty windows/tabs
- Creating terminal-based automation workflows
- Managing multiple terminal sessions programmatically
- Need precise control over terminal layout and behavior

## Basic Execution

### Execute in Focused Window
```bash
kitty @ --to unix:/tmp/kitty_{pid} launch --type=tab --title="Command Name" bash -c "your_command"
```

### Window Types

**New Tab:**
```bash
kitty @ --to unix:/tmp/kitty_{pid} launch --type=tab --title="Name" --cwd=current bash -c "command"
```

**New Window:**
```bash
kitty @ --to unix:/tmp/kitty_{pid} launch --type=window --title="Name" --cwd=current bash -c "command"
```

**Overlay Window:**
```bash
kitty @ --to unix:/tmp/kitty_{pid} launch --type=overlay --title="Name" bash -c "command"
```

**Split Window:**
```bash
kitty @ --to unix:/tmp/kitty_{pid} launch --type=window --location=vsplit --title="Name" bash -c "command"
```

## Window Management

### Close Windows
```bash
# Close by ID
kitty @ --to unix:/tmp/kitty_{pid} close-window --match=id:{window_id}

# Close by title
kitty @ --to unix:/tmp/kitty_{pid} close-window --match=title:"Window Title"
```

### Focus Windows
```bash
kitty @ --to unix:/tmp/kitty_{pid} focus-window --match=id:{window_id}
kitty @ --to unix:/tmp/kitty_{pid} focus-window --match=title:"Window Title"
```

### Send Text
```bash
kitty @ --to unix:/tmp/kitty_{pid} send-text --match=id:{window_id} "text to send"
```

### Resize Windows
```bash
kitty @ --to unix:/tmp/kitty_{pid} resize-window --match=id:{id} --increment 10
```

## Environment Detection

### Check Availability
```bash
if [ -S "/tmp/kitty_$KITTY_PID" ] && command -v kitty >/dev/null 2>&1; then
    echo "Kitty remote control available"
    KITTY_AVAILABLE=1
fi
```

### Get Window Info
```bash
# List all windows with IDs
kitty @ --to unix:/tmp/kitty_{pid} ls
```

## Common Options

| Option | Description |
|--------|-------------|
| `--hold` | Keep window open after command exits |
| `--cwd=current` | Use current working directory |
| `--copy-env` | Copy environment variables |
| `--env VAR=value` | Set specific environment variable |
| `--location=vsplit/hsplit` | Split direction for new windows |

## Examples

### Run Interactive App
```bash
kitty @ --to unix:/tmp/kitty_$KITTY_PID launch --type=tab --title="htop" --hold htop
```

### Run Command in Background Tab
```bash
kitty @ --to unix:/tmp/kitty_$KITTY_PID launch --type=tab --title="Server" --cwd=current bash -c "npm run dev"
```

### Split Screen Workflow
```bash
# Editor on left, terminal on right
kitty @ launch --type=window --location=vsplit --title="Editor" vim
cd project
kitty @ launch --type=window --location=hsplit --title="Terminal" bash
```

## Best Practices

1. Always use `--title` for easy window identification
2. Use `--cwd=current` to maintain context
3. Use `--hold` for commands that exit immediately (to see output)
4. Quote commands properly with `"` around the bash -c argument
5. Check socket availability before attempting remote control
