# bootstrap.d

Every executable file in this directory is run, in sorted order, by
`~/.config/yadm/bootstrap`, which `yadm clone` invokes automatically.

This file exists so the directory survives in git. Without it the directory
would be empty, git would not track it, and the bootstrap script would abort
with "bootstrap directory not found".

The two previous steps lived here:

- `submodule-init.bash` initialised the LunarVim and yadm submodules. The
  LunarVim gitlink was never in the tree and yadm now comes from Homebrew, so
  the repo has no submodules left.
- `gitconfigs.bash` aliased `yadm ui` to `gitui -d ~/.local/share/yadm/repo.git`.
  gitui is no longer installed; run `jjui` or `gitui` by hand if you want it back.
