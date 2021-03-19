#!/usr/bin/env sh
sudo apt-get install -y fish
chsh -s /usr/bin/fish
#fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
# Check if all fish plugins will be available already because of yadm
