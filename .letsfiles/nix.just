justrun := "just -d " + wd + " -f " + justfile()
pure := "0"
#profile := `realpath ~/.nix-profile` # DONT USE THIS: it derefs too many times
profile := '' # DONT MAKE THIS ~/.nix-profile, it should be the pointee of that symlink
user-nix := '~/install-system.sh/user.nix'

export FISH_ACTIVATE_NIX := if profile == "" { "1" } else { "" }
export FISH_ACTIVATE_NIX_PROFILE := if profile != "" { profile } else { "" }

set shell := ["fish", "-c"]

wd := invocation_directory()

nix-env := 'nix-env' + if profile == "" { "" } else { " -p " + profile }
nix-shell := if pure != "0" { "nix-shell --pure" } else { "nix-shell" }

nix-gc-roots-dir := "~/.nix-gc-roots"

# https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/

# Enter a nix environment (or run commands)
@do *commands:
    {{ if commands != "" { commands } else { "fish -i" } }}

@enter prof *commands:
    {{justrun}} profile={{prof}} do {{commands}}

# Enter a nix shell (or run commands)
@sh *command="":
    {{nix-shell}} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

# Enter a nix shell with a certain package
@sh-with name="" *command="":
    {{nix-shell}} {{ if name != "" { "-p " + name } else { "" } }} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

# Enter a nix shell for building a certain derivation
@sh-of name *command="":
    {{nix-shell}} {{name}} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

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
    {{nix-env}} --version # Check we are in an environment
    echo "======================================================="
    #delta  <({{nix-env}} -q)  <({{nix-env}} -qaf {{user-nix}})
    diff -U 0 \
      --label current <({{nix-env}} -q) \
      --label user.nix <({{nix-env}} -qaf {{user-nix}}) \
    || echo "Changes are above"

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
    {{ if zipper != "" { zipper + " -dc " + name + " |" } else { "" } }} \
    nix-store --import \
    {{ if zipper != "" { "" } else { "< " + name } }} \
#< `basename {{name}} {{zipext}}`

pin name="shell.nix":
    nix-instantiate {{name}} --indirect --add-root {{nix-gc-roots-dir}}$PWD/{{name}}.drv
