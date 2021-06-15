set shell := ["fish", "-c"]
wd := invocation_directory()

default-profile := '~/.nix-profile'
nix-env := 'nix-env -p ' + default-profile

# https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/

@_default: 
    just -f {{justfile()}} -l

@edit:
    cd {{justfile_directory()}} && nvim {{justfile()}}

@enter:
    FISH_ACTIVATE_NIX=1 fish -i

@activate profile=default-profile:
    FISH_ACTIVATE_NIX_PROFILE="{{profile}}" fish -i

@shell name profile=default-profile:
    FISH_ACTIVATE_NIX_PROFILE="{{profile}}" fish -ic "nix-shell -p {{name}}"

@pshell name profile=default-profile:
    FISH_ACTIVATE_NIX_PROFILE="{{profile}}" fish -ic "nix-shell -p {{name}} --pure"

installed:
    {{nix-env}} -q 

# Install into enviroment from file 
install-file file="~/install-system.sh/user.nix":
    {{nix-env}} -irf {{file}}

# Export a declarative file of the enviroment
@export file="~/install-system.sh/user.nix":
    echo "Exporting to {{file}}.new"
    echo "with import <nixpkgs> {}; [" > {{file}}.new
    {{nix-env}} -q  | cut -d '-' -f 1 >> {{file}}.new
    echo "]" >> {{file}}.new
    cat {{file}}.new

# What would change in my enviroment if I reinstall from the nix file
@diff file="~/install-system.sh/user.nix":
    #!/usr/bin/env bash
    set -euo pipefail
    diff -U 0 \
      --label current <({{nix-env}} -q) \
      --label user.nix <({{nix-env}} -qaf {{file}}) \
    | grep -v '^@'

# Fetch updates from nix-channel
fetch:
    nix-channel --update

gc:
    nix-collect-garbage
