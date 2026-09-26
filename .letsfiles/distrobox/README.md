# The arch dev container

`arch.ini` in this directory is the source of truth. Apply it with `lets distrobox create`
(create if absent), `lets distrobox pkgs` (sync packages into a live container) or
`lets distrobox rebuild` (destroy and recreate). `lets distrobox check` verifies
the result.

## Two tool layers, and which one wins

| Layer | Source | Cost | Examples |
|---|---|---|---|
| host toolchain | `/home/linuxbrew` mounted **read-only** | none, already installed | node, pnpm, bun, arm-none-eabi-gcc, riscv64-elf-gcc, openocd, tio, esptool, mold, clang/llvm, zig, uv |
| container-native | `pacman`, declared in `arch.ini` | a few GB, writable | go, cmake, gtk4/libadwaita/webkit2gtk, python + datascience, paru, stlink |

The image already shipped `/home/linuxbrew/.linuxbrew/bin` on `PATH` without mounting
anything, so before this every brew entry was a dead path. Verified that brew's binaries
execute inside the container despite the read-only mount — they are self-contained and
carry their own rpaths. This is why the cross-compilers match the host's versions exactly,
which matters when the same firmware is built on both sides.

**PATH precedence decides collisions.** Inside the container `PATH` is
`~/.cargo/bin ~/.bun/bin ~/.local/bin ~/bin /usr/local/bin /usr/bin /bin /home/linuxbrew/...`
so a pacman package always shadows its brew equivalent. That is deliberate: anything the
container must be able to *write* (python packages, AUR builds) is pacman-owned, everything
else leans on brew.

**Read-only is not a limitation to work around.** `brew install` inside the container would
compile against Arch's libc and drop binaries into the host Cellar that may not run on the
host. Add packages to `arch.ini` (or `pacman -S` ad hoc) instead.

**The mount has to exist when the container is created.** Volumes cannot be attached to an
existing container, so a container created before this manifest has the PATH entries but no
brew behind them, and `lets distrobox rebuild` is the only way to fix it. The tempting
shortcut of reaching the host's brew through distrobox's host root mount does not work:
`/run/host/home/linuxbrew/.linuxbrew/bin/node` exists but **will not execute** ("required file
not found") because the host's ostree/composefs root is not an executable environment from
inside the container. Verified both ways — with the volume mounted at the real path the same
binary runs and reports 26.10.0.

## Home is shared, and that cuts both ways

`$HOME` is the same directory in both places, which is what makes `~/.cargo` (rustup,
probe-rs, wild), `~/.config/fish` and `~/.local/bin` work in the container for free. It also
means shared mutable state:

- `target/`, `node_modules/`, `~/.cache/uv`, `~/.cargo/registry` are shared. Building the
  same project on both sides is fine but they will invalidate each other's caches, and a
  `.venv` created in the container uses the container's python — do not run it from the host.
  uv keeps its own CPython builds under `~/.local/share/uv/python`, and a bare
  `uv venv --python python3` resolves to one of *those* rather than the container's own 3.14;
  pin it with `--python /usr/bin/python3` when the system interpreter is what you want.
- `~/.cargo/config.toml` pins `linker = "clang"` and `-fuse-ld=wild`; both resolve inside
  the container (brew's clang, brew's `ld.wild`), so Rust builds need no special casing.
  `/usr/local/bin/ld.wild` in the container was a manual shim for this and is now redundant.

## Devices

Docker-free flashing and serial both work: `/dev` is mounted `rslave`, so USB devices
(ST-Link, DAPLink, ESP, USB-UART) appear inside as they are plugged in. The host's udev
rules (`~/.letsfiles/udev/99-platformio-udev.rules`, installed by `lets fedora udev`) set
`MODE="0666"` for those devices, so no `dialout`/`plugdev` group juggling is needed inside
the container — which is fortunate, because the container's `video`/`render`/`dialout` GIDs
do not match the host's.

## Terminal integration

Two things make a container shell behave like a kitty shell, and only one of them is automatic.

**Terminal identity comes for free.** kitty keeps its terminfo under `~/.local/kitty.app` and
exports `TERMINFO` pointing at it to every child. `$HOME` is shared, so that path resolves inside
the container and `distrobox enter arch` started from a kitty window gets a working
`xterm-kitty` — measured there as `tput -T xterm-kitty colors` → `256` and `setrgbf` emitting the
truecolor escape. No container-side setup is involved.

**`kitty-terminfo` exists because that variable does not always survive.** `sudo` resets the
environment: it keeps `TERM` but drops `TERMINFO`. Anything that loses it falls back to
`/usr/share/terminfo` — which Arch's ncurses does not populate with `xterm-kitty` — and then
every TUI misrenders (`sudo nvim` being the common case). Arch's `kitty-terminfo` (0.49.1-1,
tracking the host's kitty release exactly) puts the entry in `/usr/share/terminfo/x/xterm-kitty`.
Measured as root, both ways: `256` with it, `unknown terminal "xterm-kitty"` without.

**Shell integration does not come for free.** `distrobox enter` runs a plain login shell, so
inside the container there are no prompt marks, no cwd/window-title reporting, no
`clone-in-kitty`, no click-to-move-cursor, and prompt redraw on resize is glitchy. Upstream's
answer for containers is the run-shell kitten, which works here because `~/.local/bin/kitten` is
reachable through the shared `$HOME`:

```
distrobox enter arch -- kitten run-shell
```

Verified inside the container: `clone-in-kitty` is a function, five kitty helpers are defined,
and `PS1` carries the OSC 133 prompt marks. It also exports `TERM`/`TERMINFO` itself and aliases
`sudo` to preserve `TERMINFO`. The kitty side of this lives in
`~/.config/kitty/kitty.d/containers/containers.conf` — pulled in by a `globinclude` in
`kitty.conf`, since kitty does not read extra config files on its own — bound to `kitty_mod+o>a`.

## Adding things

- **A normal package**: add it to an `additional_packages` line in `arch.ini`, then
  `lets distrobox pkgs`. Ad-hoc `distrobox enter arch -- sudo pacman -Syu <pkg>` works too but
  is not recorded, and is lost by a rebuild. Use `-Syu` rather than `-S`: Arch does not support
  mixing old and new packages, and the cache clean in these recipes drops the sync databases.
- **An AUR package**: the `ublue-os/arch-toolbox` image already ships `paru` (its only foreign
  package), so `lets distrobox paru` is a no-op here — it exists as the guard for other images,
  or if paru ever goes missing. AUR packages cannot be declared in `arch.ini`, because distrobox
  installs `additional_packages` with pacman.
- **Not included on purpose**: `fish` (the container's bash is the distrobox default and
  your fish config assumes host paths — `distrobox enter arch -- fish` if you install it),
  `python-pytorch` (~2GB, and this machine has an Intel GPU so the CUDA builds are useless;
  use `uv pip install torch` with the XPU index if you need it), and `neovim`/`ripgrep`/`fd`
  (brew already provides them).

## Noise you can ignore

- A pacman post-transaction hook fails with `Failed to connect to udev via varlink: Permission
  denied` (`error: command failed to execute correctly`). The container has no udev — device
  rules are the host's job — so the hook has nothing to talk to. Packages still install.
- `pacman --noconfirm` answers provider questions with the default, so `python-polars` pulls
  `python-polars-runtime-32` and a `ttf-font` provider (`gnu-free-fonts`) is chosen for you.
  Fonts are cosmetic here anyway: distrobox integrates the host's fonts and icon themes.
- ~650 MB of pacman cache is left behind by a create or rebuild. That is `-Sc` working as
  intended: it drops cached packages nothing is using but keeps those for installed packages,
  the same as a normal Arch install. To take it all the way:
  `distrobox enter arch -- bash -lc 'yes | sudo pacman -Scc'`. `--noconfirm` cannot do it —
  pacman's first question defaults to **No**, which is why the recipes use `-Sc`. The
  `could not open file /var/cache/pacman/pkg/download-*` line printed during that step is
  pacman housekeeping on its own root-owned temp directory; the step still exits 0.

## Rebuilding

`distrobox-rebuild` throws away the container's root filesystem. Everything in `$HOME`
survives, and the manifest restores the rest.
