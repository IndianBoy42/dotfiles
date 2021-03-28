#!/usr/bin/env fish

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install IlanCosman/tide \
 PatrickF1/fzf.fish \
 edc/bass \
 FabioAntunes/fish-nvm \
 jorgebucaran/autopair.fish \
 gazorby/fish-abbreviation-tips \
 mattgreen/park.fish
fisher update
