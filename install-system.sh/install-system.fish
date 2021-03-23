#!/usr/bin/env fish
mkdir -p ~/bin

# just upgrade everything once
sudo apt-get dist-upgrade

# Essential
sudo apt-get install -y apt-transport-http\
    curl \
    wget \
    build-essential \
    gnupg2 \
    lsb-release

xmodmap ~/.xmodmap-capslockmod

# install from all the "package managers"
fish ~/.install-system/install-nvim.fish
fish ~/.install-system/install-nf.fish
fish ~/.install-system/install-apt.fish
fish ~/.install-system/install-py.fish
fish ~/.install-system/install-jl.fish
fish ~/.install-system/install-brew.fish
fish ~/.install-system/install-node.fish
fish ~/.install-system/install-go.fish
fish ~/.install-system/install-flatpak.fish
