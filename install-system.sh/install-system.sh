#!/usr/bin/env bash
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
mkdir -p ~/.local/share
mkdir -p ~/.local/packages
