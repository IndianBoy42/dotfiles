#!/usr/bin/env bash
mkdir -p ~/bin

# just upgrade everything once
sudo apt-get update
# sudo apt-get dist-upgrade

# Essential
sudo apt-get install \ 
    apt-transport-https \
    curl wget build-essential \
    gnupg2 gnupg ca-certificates \
    lsb-release

# Install Just command runner for installing the rest of the stuff
if ! command -v just
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin
end
