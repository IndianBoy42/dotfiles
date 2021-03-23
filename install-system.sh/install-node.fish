#!/usr/bin/env fish

# Install/Update nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
# The nvm.fish plugin should already be synced due to yadm
nvm install --lts node npm
nvm install stable 

nvm use --lts
