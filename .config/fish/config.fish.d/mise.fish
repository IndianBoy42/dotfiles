# mise activation.
#
# This has to live in config.fish.d (sourced at the end of ~/.config/fish/config.fish)
# and NOT in conf.d/. fish sources its conf.d directories before the vendor
# configuration, and Homebrew is only put on PATH by
# /usr/share/fish/vendor_conf.d/ublue-brew.fish -- so at conf.d time `mise`, which is a
# Homebrew binary, is not on PATH yet. A conf.d activation therefore failed with
# "Unknown command: mise" on every startup, from the hook-env call that runs while the
# activation file is sourced.
#
# Sourcing the activation instead of committing mise's generated file also keeps PATH
# dynamic: `mise activate fish` emits a snapshot of the current PATH, which would then
# be wrong on any other machine. This is the same arrangement mise's own installer uses
# for fish (it appends activation to ~/.config/fish/config.fish).
#
# command -sq (not `type -q`) so the check looks for the binary: `type -q mise` matches
# the `mise` wrapper function itself and would pass even with the binary missing.
if command -sq mise
    mise activate fish | source
end
