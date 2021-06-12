#!/usr/bin/env fish
mkdir -p ~/bin


# just upgrade everything once
sudo apt-get update
# sudo apt-get dist-upgrade

# Essential
sudo apt-get install apt-transport-https \
    curl \
    wget \
    build-essential \
    gnupg2 \
    lsb-release

# install from all the "package managers"
