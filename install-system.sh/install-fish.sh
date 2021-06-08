#!/usr/bin/env sh
set -e

sudo apt-add-repository ppa:fish-shell/release-3 && sudo apt-get install fish
chsh -s /usr/bin/fish
#fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
# Check if all fish plugins will be available already because of yadm
fish -c "curl -sL https://git.io/fisher | source && fisher update"
fish
