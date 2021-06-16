#!/usr/bin/env bash
set -euxo pipefail

mkdir -p ~/bin

# just upgrade everything once
sudo apt-get update
# sudo apt-get dist-upgrade

# Essential Basics
sudo apt-get install `cat system.apt`

# Install Just command runner for installing the rest of the stuff
if ! command -v just
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin
end

# Create home local dir structure
mkdir -p ~/.local/bin
mkdir -p ~/.local/lib
mkdir -p ~/.local/include
mkdir -p ~/.local/libexec
mkdir -p ~/.local/packages
mkdir -p ~/.local/share/info
chmod o+w ~/.local/share/info

echo "Change the following:"
echo"  34   │ #RuntimeDirectorySize=50%"
echo"  35   │ #RuntimeDirectoryInodes=1000k"
sudo nano /etc/systemd/logind.conf

getent group uinput || sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo usermod -aG input $USER
sudo modprobe uinput
sudo cp ./uinput.rules /etc/udev/rules.d/uinput.rules

getent group docker || sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 

# Install fish
./install-fish.sh

read  -n 1 -p 'Reboot now? (you should):'
echo ""
sudo reboot now
