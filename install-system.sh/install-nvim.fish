#!/usr/bin/env fish

# ensure
sudo apt install neovim

#
function neovim-from-source
    cd ~/git-builds/
    git clone https://github.com/neovim/neovim.git
    cd neovim 
    make CMAKE_BUILD_TYPE=Release;
    and make CMAKE_INSTALL_PREFIX=$HOME/.local/nvim install
end

# install from my dotfiles
yadm submodule update --init ~/.config/nvim
fish -c "cd ~/.config/nvim/ && git remote add upstream https://github.com/ChristianChiarulli/LunarVim.git"
nvim -u $HOME/.config/nvim/init.lua +PackerInstall
nvim --headless +'LspInstall latex'
nvim --headless +'LspInstall rust'
nvim --headless +'LspInstall python'
nvim --headless +'LspInstall cpp'
# install from the repo
# bash <(curl -s https://raw.githubusercontent.com/IndianBoy42/lunarvim/master/utils/installer/install.sh)

function install-neovide # optional function for installing neovide
    sudo apt install -y curl \
        gnupg ca-certificates git \
        gcc-multilib g++-multilib cmake libssl-dev pkg-config \
        libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
        libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libsdl2-dev

    wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo apt-key add -
    sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-focal.list https://packages.lunarg.com/vulkan/lunarg-vulkan-focal.list
    sudo apt update
    sudo apt install vulkan-sdk

    cd ~/git-builds
    git clone "https://github.com/Kethku/neovide"
    cd neovide
    # cargo build --release
    cargo install --path .
end
