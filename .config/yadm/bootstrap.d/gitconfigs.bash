#!/usr/bin/env bash
# Repo-level git settings for the yadm repo.
#
# These CANNOT live in ~/.config/yadm/config: yadm only reads that file for its
# own `yadm config` command, so git never sees anything in it. Unknown yadm
# subcommands are forwarded to git, which is why `yadm gitconfig` writes to the
# repo config git actually reads ($HOME/.local/share/yadm/repo.git/config).
#
# Consequence: everything below is machine-local and must be (re)applied by
# `yadm bootstrap` after a clone. That is why this file exists.
set -eu

# Without this, the ignore list is inert and the pre_status auto-track hook
# re-commits every fisher-managed plugin file under .config/fish, which is what
# broke `fisher update` on this machine.
yadm gitconfig core.excludesFile '~/.config/yadm/.yadmignore'

# `yadm trackdir` is the documented way to mark a directory for auto-tracking by
# .config/yadm/hooks/track_directories.py; it is a git alias, so it belongs here.
yadm gitconfig alias.trackdir '!touch .yadmtrack && yadm add .yadmtrack'
