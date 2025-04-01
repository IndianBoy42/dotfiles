#!/usr/bin/env sh
set -e

sudo apt-add-repository ppa:fish-shell/release-4 && sudo nala install fish
chsh -s /usr/bin/fish
#fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher" # Without plugins
fish -c "curl -sL https://git.io/fisher | source && fisher update"
fish # Start fish shell (hopefully my config doesn't depend on nonexistent programs)
