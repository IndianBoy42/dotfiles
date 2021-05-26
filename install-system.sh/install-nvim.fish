#!/usr/bin/env fish
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)
#sh -c 'curl -fLo ~/.config/nvim/site/autoload/plug.vim --create-dirs \
#       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

function install-neovide
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
    cargo build --release
end
