pure := "0"
profile := '~/.nix-profile'
user-nix := '~/install-system.sh/user.nix'

export FISH_ACTIVATE_NIX := if profile == "" { "1" } else { "" }
export FISH_ACTIVATE_NIX_PROFILE := if profile != "" { profile } else { "" }

set shell := ["fish", "-c"]

wd := invocation_directory()

nix-env := 'nix-env -p ' + profile
nix-shell := if pure != "0" { "nix-shell --pure" } else { "nix-shell" }

# https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/

# Enter a nix environment (or run commands)
@do *commands:
    {{ if commands != "" { commands } else { "fish -i" } }}

# Enter a nix shell (or run commands)
@sh name="" *command="":
    {{nix-shell}} {{ if name != "" { "-p " + name } else { "" } }} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

@edit:
    cd {{justfile_directory()}} && nvim {{justfile()}}

installed:
    {{nix-env}} -q 

############################
#  Manage nix environment  #
############################

# Install into enviroment from file 
install-user:
    {{nix-env}} -irf {{user-nix}}

# Edit the user.nix file
edit-user:
    $EDITOR {{user-nix}}
    echo "Install now? [y/N]" && confirm && just -f {{justfile()}} install-file {{user-nix}}

# Export a declarative file of the enviroment
@export-user:
    echo "Exporting to {{user-nix}}.new"
    cp {{user-nix}} {{user-nix}}.old || true
    echo "with import <nixpkgs> {}; [" > {{user-nix}}.new
    {{nix-env}} -q  | cut -d '-' -f 1 >> {{user-nix}}.new
    echo "]" >> {{user-nix}}.new
    cat {{user-nix}}.new
    diff {{user-nix}}.new {{user-nix}}.old || true
    echo "replace {{user-nix}}? [y/N]" && confirm && cp {{user-nix}}.new {{user-nix}}

# What would change in my enviroment if I reinstall from the nix file
@diff:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "======================================================="
    diff -U 0 \
      --label current <({{nix-env}} -q) \
      --label user.nix <({{nix-env}} -qaf {{user-nix}}) \
    | grep -v '^@' || echo "Changes are above"

# Fetch updates from nix-channel
fetch:
    nix-channel --update

gc:
    nix-collect-garbage

zipper := "zstd"
zipext := zipper
export name out="": 
    nix-store --export (nix-store -qR {{name}}) \
    {{ if zipper != "" { "| " + zipper } else { "" } }} \
    >  {{ if out == "" { "(basename " + name + ")" } else { out } }}.closure\
    {{ if zipper != "" { "." + zipext } else { "" } }}

import name:
    nix-store --import < {{name}}
