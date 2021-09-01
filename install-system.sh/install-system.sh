#!/usr/bin/env bash
set -euxo pipefail

# On Pop-os, fake distro-info (idk why)
sudo cp /usr/share/distro-info/ubuntu.csv /usr/share/distro-info/pop.csv || true


# just upgrade everything once
sudo apt-get update
# sudo apt-get dist-upgrade

# Essential Basics
sudo apt-get install `cat system.apt`

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

# Setup some permissions for kmonad 
getent group uinput || sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo usermod -aG input $USER
sudo modprobe uinput
sudo cp ./uinput.rules /etc/udev/rules.d/uinput.rules

# Setup some permissions for docker 
getent group docker || sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 

# Install some apps
# Install Just command runner for installing the rest of the stuff
./install-fish.sh
if ! command -v just
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /tmp/bin
    /tmp/bin/just just
end
just getgh
just nix

read -n 1 -p 'Reboot now? (you should):'
echo ""
sudo reboot now

