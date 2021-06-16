set shell := ["fish", "-c"]
wd := invocation_directory()

default-profile := '~/.nix-profile'
nix-env := 'nix-env -p ' + default-profile

# https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/

# Enter a nix environment
@env profile="":
    {{ if profile == "" { "FISH_ACTIVATE_NIX=1" } else { "FISH_ACTIVATE_NIX_PROFILE=" + profile } }} \
    fish -i

@do command profile="":
    {{ if profile == "" { "FISH_ACTIVATE_NIX=1" } else { "FISH_ACTIVATE_NIX_PROFILE=" + profile } }} \
    fish -ic {{command}}

@_default:
    just -f {{justfile()}} --list

@edit:
    cd {{justfile_directory()}} && nvim {{justfile()}}

@sh name command="" profile=default-profile:
    FISH_ACTIVATE_NIX_PROFILE="{{profile}}" \
    fish -c 'nix-shell -p {{name}} {{ if command != "" {"--command \""+command + "\""} else {""} }}'

@prsh name command="" profile=default-profile:
    FISH_ACTIVATE_NIX_PROFILE="{{profile}}" \
    fish -c 'nix-shell -p {{name}} {{ if command != "" {"--command \""+command + "\""} else {""} }}'

installed:
    {{nix-env}} -q 

# Install into enviroment from file 
install file="~/install-system.sh/user.nix":
    {{nix-env}} -irf {{file}}

# Edit the user.nix file
edit-user file="~/install-system.sh/user.nix":
    $EDITOR {{file}}
    echo "Install now? [y/N]" && confirm && just -f {{justfile()}} install-file {{file}}

# Export a declarative file of the enviroment
@export file="~/install-system.sh/user.nix":
    echo "Exporting to {{file}}.new"
    cp {{file}} {{file}}.old || true
    echo "with import <nixpkgs> {}; [" > {{file}}.new
    {{nix-env}} -q  | cut -d '-' -f 1 >> {{file}}.new
    echo "]" >> {{file}}.new
    cat {{file}}.new
    diff {{file}}.new {{file}}.old || true
    echo "replace {{file}}? [y/N]" && confirm && cp {{file}}.new {{file}}

# What would change in my enviroment if I reinstall from the nix file
@diff file="~/install-system.sh/user.nix":
    #!/usr/bin/env bash
    set -euo pipefail
    echo "======================================================="
    diff -U 0 \
      --label current <({{nix-env}} -q) \
      --label user.nix <({{nix-env}} -qaf {{file}}) \
    | grep -v '^@' || echo "Changes are above"

# Fetch updates from nix-channel
fetch:
    nix-channel --update

gc:
    nix-collect-garbage
