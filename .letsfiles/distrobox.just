#!/usr/bin/env just --justfile
# The arch dev container: go + html/js, rust (cli + gui), c/c++ embedded, python datascience.
#
# distrobox/arch.ini is the source of truth for what is installed inside it, and
# distrobox/README.md explains the read-only brew mount vs pacman-owned split. Nothing
# about the package list is duplicated here — the body reads it out of the manifest, so
# the two cannot drift.
set shell := ["fish", "-c"]
wd := justfile_directory()
ini := wd + "/distrobox/arch.ini"
container := "arch"

@_default:
    just -f {{justfile()}} -l

# Create the container if it is missing. Safe to re-run; does not touch an existing one.
create:
    #!/usr/bin/env fish
    if podman container exists {{container}}
        echo "container '{{container}}' already exists:"
        echo "  lets distrobox pkgs      sync the packages declared in arch.ini into it"
        echo "  lets distrobox rebuild   destroy and recreate it from arch.ini"
        echo "  lets distrobox check     verify the toolchains inside it"
        return
    end
    distrobox assemble create --file {{ini}}
    podman container exists {{container}}; and distrobox enter {{container}} -- sudo pacman -Sc --noconfirm

# Install/refresh everything declared in arch.ini. Idempotent (--needed) and additive:
# packages installed by hand are left alone, so this is the right recipe for a container
# that already exists.
pkgs:
    #!/usr/bin/env fish
    set -l pkgs (grep '^additional_packages=' {{ini}} | sed 's/^additional_packages="//; s/"$//' | tr ' ' '\n' | sort -u)
    echo "syncing "(count $pkgs)" packages into '{{container}}'"
    distrobox enter {{container}} -- sudo pacman -Syu --needed --noconfirm $pkgs
    # the package cache is dead weight in a container that can be recreated from arch.ini
    distrobox enter {{container}} -- sudo pacman -Sc --noconfirm

# Destroys the container's root filesystem and rebuilds it from arch.ini.
# $HOME survives; ad-hoc pacman installs and the AUR helper do not.
rebuild:
    #!/usr/bin/env fish
    distrobox assemble create --replace --file {{ini}}
    podman container exists {{container}}; and distrobox enter {{container}} -- sudo pacman -Sc --noconfirm
    echo "rebuilt from arch.ini — now run `lets distrobox paru` and `lets distrobox check`"

# AUR helper. paru-bin is prebuilt so there is no compiler round trip. AUR packages
# cannot be declared in arch.ini, because distrobox installs additional_packages with
# pacman, which is why this is a separate step.
paru:
    #!/usr/bin/env fish
    if distrobox enter {{container}} -- bash -lc 'command -v paru' >/dev/null 2>&1
        echo "paru is already installed inside '{{container}}'"
        return
    end
    distrobox enter {{container}} -- bash -lc 'cd /tmp && rm -rf paru-bin && git clone --quiet https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm'

# Proves each workload actually compiles inside the container, not just that binaries
# exist. The script lives in distrobox/check.sh and is read from the shared $HOME.
check:
    distrobox enter {{container}} -- bash {{wd}}/distrobox/check.sh
