#!/usr/bin/env fish
mkdir -p ~/bin

sudo usermod -aG docker $USER

# just upgrade everything once
sudo apt-get update
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
fish ~/install-system.sh/install-nvim.fish
fish ~/install-system.sh/install-code.fish
fish ~/install-system.sh/install-apt.fish
fish ~/install-system.sh/install-py.fish
fish ~/install-system.sh/install-jl.fish
fish ~/install-system.sh/install-brew.fish
fish ~/install-system.sh/install-node.fish
fish ~/install-system.sh/install-go.fish
fish ~/install-system.sh/install-flatpak.fish
fish ~/install-system.sh/install-nf.fish
