# Order of operation

```
# Install YADM and pull my dotfiles
# Use a temporary yadm to clone the dotfiles
# curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
  && chmod +x /tmp/yadm \
  && /tmp/yadm clone https://github.com/IndianBoy42/dotfiles.git
# Use official bootstrap script
source <(curl -L bootstrap.yadm.io)
yadm clone https://github.com/IndianBoy42/dotfiles.git
curl -L bootstrap.yadm.io | bash -s -- https://github.com/IndianBoy42/dotfiles.git

# Install all the alternatives
yadm config local.class {Laptop|Desktop} && yadm alt

# Start installing all programs

# On Pop-os, fake distro-info (idk why)
sudo cp /usr/share/distro-info/ubuntu.csv /usr/share/distro-info/pop.csv || true

# just upgrade everything once
sudo apt install nala
sudo nala fetch
sudo nala update
# sudo nala dist-upgrade

# Essential Basics
sudo nala install `cat system.apt`

# Create home local dir structure
mkdir -p ~/bin
mkdir -p ~/.local/bin
mkdir -p ~/.local/lib
mkdir -p ~/.local/include
mkdir -p ~/.local/libexec
mkdir -p ~/.local/packages
mkdir -p ~/.local/share/info
mkdir -p ~/.git-builds/
mkdir -p /dev/
sudo chmod a+w ~/.local/share/info
# sudo chmod a+rw ~/.local/share/hicolor/*

# Edit some configs for nix
echo "Change the following:"
echo "  34   │ #RuntimeDirectorySize=50%"
echo "  35   │ #RuntimeDirectoryInodes=1000k"
read -n 1 -p 'Opening /etc/systemd/logind.conf now'
sudo nano /etc/systemd/logind.conf

echo "Change the following:"
echo "fs.inotify.max_user_watches=1048576"
echo "fs.inotify.max_queued_events=1048576"
echo "fs.inotify.max_user_instances=256"
read -n 1 -p 'Opening /etc/sysctl.d/98-inotify-higher.conf now'
sudo nano /etc/sysctl.d/98-inotify-higher.conf

# Install some apps
# Fish of course
./install-fish.sh
# Install Just command runner for installing the rest of the stuff
if ! command -v just
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /tmp/bin
    /tmp/bin/just just
end
# Github cli
just gh-cli
just git
# just nix
just pacstall
just stow

read -n 1 -p 'Reboot now? (you should):'
echo ""
sudo reboot now

## AFTER REBOOT

# just add-local-repo # if have
# lets nix install-user
just apt-libs
just apt-apps
just sublime-merge
just cmake fzf zstd git-subrepo
just mold
just nvim
just rustc
just cargo-all
just tectonic
just kmonad # if a laptop
just howdy # if a laptop
```

I wish I could install `neovim` earlier because I inevitably have to edit configs and scripts before I get to that stage

# TODO

I should use nix for more tools, instead of apt
