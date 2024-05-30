set shell := ["fish", "-c"]

# TODO: DONT USE nix-env ???
# https://www.youtube.com/watch?v=CwfKlX3rA6E
# https://tech.aufomm.com/my-nix-journey-use-nix-with-ubuntu/
# https://www.youtube.com/watch?v=a67Sv4Mbxmc

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

# Remove all system paths (pure functional dev environment)
pure := "0"

# Profile for nix-env
profile := '' # DONT MAKE THIS ~/.nix-profile, it should be the pointee of that symlink
#profile := `realpath ~/.nix-profile` # DONT USE THIS: it derefs too many times

# Some additional packages for nix-shell
with := ""

#####################################################################################
# Configuration above, recipes and derived variables below
#####################################################################################

# https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/
# File to store user enviroment 
user-nix := '~/install-system.sh/user.nix'

# Export variables to make fish activate nix correctly
export FISH_ACTIVATE_NIX := if profile == "" { "1" } else { "" }
export FISH_ACTIVATE_NIX_PROFILE := if profile != "" { profile } else { "" }

# Add profile to nix-env automatically
nix-env := 'nix-env' + if profile == "" { "" } else { " -p " + profile }

# Add `with`
add-with :=  if with == "" { "" } else { " -p " + with } 
nix-shell := if pure != "0" { "nix-shell --pure" + add-with } else { "nix-shell" + add-with }

# Location to store gc-roots
nix-gc-roots-dir := "~/.nix-gc-roots"

# Enter a nix environment determined by the `profile variable` (or run commands)
@do *commands:
    {{ if commands != "" { commands } else { "fish -i" } }}

# Enter a specific nix profile (equiv to `profile=$argv[1] do`)
@enter prof *commands:
    {{justrun}} profile={{prof}} do {{commands}}

# Enter a nix-shell (or run commands)
@sh *command="":
    {{nix-shell}} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

# Can use "nix run"
# Enter a nix-shell with certain packages installed
@run name *command="":
    nix run {{name}} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}
#{{nix-shell}} -p {{name}} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

# Can use "nix develop" when available
# Enter a nix shell for building a certain derivation
@dev name *command="":
    {{nix-shell}} {{name}} {{ if command != "" { "--command \"" +command + "\"" } else { "" } }}

# Edit this Letsfile
@edit:
    cd {{justfile_directory()}} && nvim {{justfile()}}

# List installed derivations (must be in an environment to do)
installed:
    {{nix-env}} -q 

# Install into nix environment
install +arguments:
    {{nix-env}} -iA {{arguments}}

############################
#  Manage nix environment  #
############################

# Install into enviroment from file (generally use the result of `lets nix export-user`)
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
    {{nix-env}} -q  | sed -r 's/^(.*)-.*$/\1/' >> {{user-nix}}.new
    echo "]" >> {{user-nix}}.new
    cat {{user-nix}}.new
    diff {{user-nix}}.old {{user-nix}}.new || true
    echo "replace {{user-nix}}? [y/N]" && confirm && cp {{user-nix}}.new {{user-nix}}

# What would change in my enviroment if I install from the user.nix file
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
update:
    nix-channel --update

# Delete old generations and GC the rest
gc:
    nix-collect-garbage

zipper := "zstd"
zipext := zipper
# Export the closure of a derivation into a file (uses the zipper file to compress the data)
export name out="": 
    nix-store --export (nix-store -qR {{name}}) \
    {{ if zipper != "" { "| " + zipper } else { "" } }} \
    >  {{ if out == "" { "(basename " + name + ")" } else { out } }}.closure\
    {{ if zipper != "" { "." + zipext } else { "" } }}

# Import all the packages from a closure file, will decompress the file on the fly (thanks zst)
import name:
    {{ if zipper != "" { zipper + " -dc " + name + " |" } else { "" } }} \
    nix-store --import \
    {{ if zipper != "" { "" } else { "< " + name } }} \
#< `basename {{name}} {{zipext}}`

# Pin a nix-shell dev environment so it doesn't get garbage collected
pin name="shell.nix":
    nix-instantiate {{name}} --indirect --add-root {{nix-gc-roots-dir}}$PWD/{{name}}.drv
