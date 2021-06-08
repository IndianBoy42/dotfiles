#!/usr/bin/env sh
# This probably will need to be run separately

# Use a temporary yadm to clone the dotfiles
curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod +x /tmp/yadm
/tmp/yadm clone https://github.com/IndianBoy42/dotfiles.git
