---
name: jujutsu
description: Guide to Jujutsu (jj) version control system. Use when working with commits, branches, pull requests, PRs, version control, rebasing, pushing, or when the user mentions jj, git, or version control operations.
---

# Jujutsu (jj) Version Control Guide

Jujutsu is a modern, Git-compatible version control system. This project uses jj colocated with git.

## Key Differences from Git

| Concept | Git | Jujutsu |
|---------|-----|---------|
| Staging area | Explicit `git add` | None - working copy IS a commit |
| Branches | Named refs | Bookmarks (auto-follow rewrites) |
| Stash | Separate stash stack | Not needed - just use commits |
| Amend | `git commit --amend` | Just edit files, or use `jj squash` |
| Identity | Commit ID only | Change ID (stable) + Commit ID |

## Essential Commands

| Task | Command |
|------|---------|
| Status | `jj status` or `jj st` |
| Diff | `jj diff` |
| Log | `jj log` |
| Commit & continue | `jj commit -m "message"` |
| Update message | `jj describe -m "message"` |
| New empty commit | `jj new` |
| Squash into parent | `jj squash` |
| Undo last operation | `jj undo` |
| Fetch from remote | `jj git fetch` |
| Push to remote | `jj git push` |
| Create & push bookmark | `jj git push --named name=@` |
| Push existing bookmark | `jj git push --bookmark name` |

## Working Copy Model

The working copy (`@`) is always a commit. File changes are automatically tracked - no staging required.

```
parent commit
    ↓
@ (working copy) ← your edits go here automatically
```

## Quick Git-to-Jujutsu Translation

| Git | Jujutsu |
|-----|---------|
| `git status` | `jj st` |
| `git diff` | `jj diff` |
| `git log` | `jj log` |
| `git add . && git commit -m "msg"` | `jj commit -m "msg"` |
| `git push` | `jj git push` |
| `git pull` | `jj git fetch` then `jj rebase -d main@origin` |
| `git checkout -b branch` | `jj new main` then `jj bookmark set branch` |
| `git branch` | `jj bookmark list` |
| `git stash` | `jj new` (just start new commit) |
| `git blame` | `jj file annotate` |

# Jujutsu Workflows

Common development workflows and patterns for jj.

## Understanding the Working Copy Model

In jj, there's no staging area. The working copy IS a commit that updates automatically:

```
main
  │
  ├── feature-commit (parent)
  │     │
  │     └── @ (working copy - your current edits)
```

When you edit files, they're immediately part of the working copy commit. This is fundamentally different from git.

## Basic Development Workflow

### Starting New Work

```bash
# Check the current state
jj status

# If the working copy has changes you should create a new commit (on top of it)
# Start a new feature (it already has a commit message here, start with a one liner about what work you will do)
jj new -m "Add new feature"
# If the working copy was already clean just add a commit message to the working copy
jj describe -m "Add new feature"

# Edit files... changes are tracked automatically

# (OPTIONAL) When done, describe your work (expand on the previous oneliner commit message with details and learnings)
jj describe -m "Implement feature X"
```



## Handling Conflicts

Conflicts in jj are first-class citizens - they're stored in commits and don't block operations.

### When Conflicts Occur

```bash
# After a rebase that causes conflicts, jj shows them
jj status
# Shows: Conflicted files: src/main.rs

# Resolve interactively
jj resolve

# Or resolve specific file
jj resolve src/main.rs

# Accept one side entirely
jj resolve --tool=:ours
jj resolve --tool=:theirs
```

### Viewing Conflict Markers

Conflict markers in files look like:

```
<<<<<<< Conflict 1 of 1
%%%%%%% Changes from base to side #1
-old line
+modified in first branch
+++++++ Contents of side #2
modified in second branch
>>>>>>>
```

## Common Patterns Summary

| Goal | Commands |
|------|----------|
| Start feature | `jj new main -m "Feature"` |
| Save progress | `jj commit -m "WIP"` or `jj squash` |
| Fix old commit | `jj edit <id>`, fix, `jj new` |
| Update from main | `jj git fetch && jj rebase -d main@origin` |
| Push feature | `jj bookmark set X && jj git push --bookmark X` |
| Undo mistake | `jj undo` |

## Additional References

- [commands-reference.md](commands-reference.md) - Complete command reference
- [revsets.md](revsets.md) - Revision selection syntax
