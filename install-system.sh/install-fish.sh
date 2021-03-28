#!/usr/bin/env sh
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get install -y fish
chsh -s /usr/bin/fish
#fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
# Check if all fish plugins will be available already because of yadm
fish -c "source install-fisher.fish"
