#!/usr/bin/env fish
sudo apt install -y neovim
sh -c 'curl -fLo ~/.config/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
