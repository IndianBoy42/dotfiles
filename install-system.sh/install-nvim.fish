#!/usr/bin/env fish
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
sh -c 'curl -fLo ~/.config/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
