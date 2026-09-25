#!/usr/bin/env just --justfile
# Install layer for Aurora (Universal Blue Fedora-atomic / KDE).
#
# Aurora is immutable: /usr is read-only and there is no apt. Supported order of
# preference is flatpak (GUI) > homebrew (CLI) > distrobox (everything else), with
# rpm-ostree layering as a last resort.
#
# The Ubuntu layer this replaces (nala/apt, PPAs, pacstall, deb repos, /usr/local stow)
# is archived in git history at commit 85a0224 — do not resurrect it.
set shell := ["fish", "-c"]
wd := justfile_directory()

@_default:
    just -f {{justfile()}} -l

# --- CLI tooling -----------------------------------------------------------------

brew:
    brew bundle --file={{wd}}/Brewfile

# probe-rs is not packaged in homebrew or Fedora; upstream installer, lands in ~/.local/bin
probe-rs:
    curl -LsSf https://github.com/probe-rs/probe-rs/releases/latest/download/probe-rs-tools-installer.sh | sh

# --- GUI apps --------------------------------------------------------------------

flatpak-apps:
    flatpak install --or-update flathub \
        com.spotify.Client \
        com.todoist.Todoist \
        org.videolan.VLC \
        nz.mega.MEGAsync \
        org.kicad.KiCad \
        org.kicad.KiCad.Library.Symbols \
        org.kicad.KiCad.Library.Footprints \
        org.kicad.KiCad.Library.Packages3D \
        org.kicad.KiCad.Library.Templates

# --- kitty -----------------------------------------------------------------------

# kitty has no flatpak, and the Fedora package would need a permanent deployment layer.
# The upstream binary installer keeps it self-contained in $HOME and survives OS updates.
# Re-run this recipe to update it.
kitty:
    #!/usr/bin/env fish
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
    mkdir -p $HOME/.local/share/applications
    # kitty must not be copied out of its app dir, only symlinked, and the symlink has to
    # live somewhere on the system-wide PATH or .desktop launches will not find it
    ln -sf $HOME/.local/kitty.app/bin/kitty $HOME/.local/kitty.app/bin/kitten $HOME/.local/bin/
    cp -f $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
    test -e $HOME/.local/kitty.app/share/applications/kitty-open.desktop; and cp -f $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
    sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" $HOME/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop
    update-desktop-database $HOME/.local/share/applications
    # kitty-open.desktop claims inode/directory; dolphin should keep that
    xdg-mime default org.kde.dolphin.desktop inode/directory
    xdg-mime default kitty.desktop x-scheme-handler/terminal

# --- device access ---------------------------------------------------------------

# udev only reads /usr/lib/udev/rules.d and /etc/udev/rules.d, so a copy under $HOME is
# inert — which is what the old .config/udev/rules.d/99-platformio-udev.rules was.
# /etc survives Aurora updates.
# Covers ST-Link, CMSIS-DAP/DAPLink, J-Link and CP210x/FT231x/CH34x/CH9102 USB-UART.
udev:
    sudo cp {{wd}}/udev/99-platformio-udev.rules {{wd}}/udev/uinput.rules /etc/udev/rules.d/
    sudo udevadm control --reload
    sudo udevadm trigger

# kanata's config and unit live in ~/qmk_userspace/kanata (separate repo, NOT the dotfiles)
kanata: udev
    #!/usr/bin/env fish
    getent group uinput >/dev/null; or sudo groupadd -r uinput
    sudo usermod -aG uinput $USER
    ln -sf $HOME/qmk_userspace/kanata/kanata.service $HOME/.config/systemd/user/kanata.service
    systemctl --user daemon-reload
    systemctl --user enable --now kanata.service

# --- verification ----------------------------------------------------------------

check:
    #!/usr/bin/env fish
    for t in brew flatpak distrobox fish kitty yadm stow just nvim jj jjui kanata tio esptool openocd arm-none-eabi-gcc riscv64-elf-gcc probe-rs wild mold
        if type -q $t
            echo "ok   $t"
        else
            echo "MISS $t"
        end
    end
