#!/usr/bin/env fish

# make sure this is installed and use it for everything
sudo apt install checkinstall
mkdir -p ~/git-builds
cd ~/git-builds

# Ultimate Plumber, live shell pipelines cd /tmp/
wget https://github.com/akavel/up/releases/latest/download/up
chmod +x /tmp/up
mv /tmp/up ~/bin/

# KMonad, cross platform QMK for all keyboards 
sudo apt install input-utils evtest
wget https://github.com/kmonad/kmonad/releases/download/0.4.1/kmonad-0.4.1-linux -O /tmp/kmonad
chmod +x /tmp/kmonad

sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo usermod -aG input $USER
sudo modprobe uinput
sudo touch /etc/udev/rules.d/uinput.rules
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/uinput.rules
echo "The next output will help you find the device that your keyboard corresponds to"
cat /proc/bus/input/devices | rg -C5 keyboard
  
sudo cp ./kmonad.service /etc/systemd/user/kmonad.service
mv /tmp/kmonad ~/bin/

sudo systemctl enable kmonad.service

# Wezterm -- cool terminal?
wget https://github.com/wez/wezterm/releases/download/nightly/WezTerm-nightly-Ubuntu16.04.AppImage -O /tmp/wezterm
chmod +x /tmp/wezterm
mv /tmp/wezterm ~/bin

# Zenith -- better top
wget https://github.com/bvaisvil/zenith/releases/download/0.12.0/zenith_0.12.0-1_amd64.deb -O /tmp/zenith.deb
sudo dpkg -i /tmp/zenith.deb

# PathPicker -- terminal path picker
cd ~/git-builds/
git clone https://github.com/facebook/PathPicker --depth 1
cd PathPicker/debian
sh ./package.sh
sudo dpkg -i ../*.deb

# cod -- completion learning daemon
# remember to activate go: gvm use 16
go get -u github.com/dim-an/cod

# gnome-quake
# go to https://extensions.gnome.org/extension/1411/quake-mode/

# localtunnel
npm install -g localtunnel

# nnn - not that, its a file manager
wget https://github.com/jarun/nnn/releases/download/v4.0/nnn_4.0-1_ubuntu20.04.amd64.deb -O /tmp/nnn.deb
sudo dpkg -i /tmp/nnn.deb
sudo apt install suckless-tools sxiv xdotool

# vscode font for broot
wget https://github.com/Canop/broot/raw/master/resources/icons/vscode/vscode.ttf -O ~/.local/share/fonts/vscode.ttf

# kitty terminal
cd ~/git-builds/
wget https://sw.kovidgoyal.net/kitty/installer.sh -O /tmp/kitty-installer.sh
sudo checkinstall sh -c /tmp/kitty-installer.sh
ln -s $HOME/.local/kitty.app/bin/kitty ~/bin/

# tinycc compiler
cd ~/git-builds/
git clone https://github.com/TinyCC/tinycc.git
cd tinycc
./configure --extra-cflags='-O3 -march=native -mtune=native' --extra-ldflags='-march=native -mtune=native' --cc=clang-12 && make && checkinstall

# keynav
cd ~/git-builds/
git clone --depth 1 https://github.com/jordansissel/keynav.git
cd keynav
sudo apt-get install libcairo2-dev libxinerama-dev libxdo-dev
make && sudo checkinstall

# zig compiler
cd ~/git-builds/
git clone https://github.com/ziglang/zig.git --depth 1
sudo apt install libllvm12 libclang-12-dev liblld-12-dev
cd zig
mkdir build;
and cd build;
and cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DZIG_TARGET_MCPU=native ..;
and checkinstall ninja install

# git-subrepo
cd ~/git-builds
git clone https://github.com/ingydotnet/git-subrepo

# indexa
cd ~/git-builds
git clone https://github.com/mosmeh/indexa.git --depth 1
cd index
cargo install --path .

# godbolt
cd ~/git-builds
git clone https://github.com/compiler-explorer/comp
iler-explorer.git
cargo install rustfilt

# zapcc
# !! This must only be done manually it takes so much gd RAM and Disk
# cd ~/git-builds
# git clone https://github.com/yrnkrn/zapcc.git
# cmake -DLLVM_ENABLE_WARNINGS -DLLVM_USE_LINKER=gold ..

# google benchmark
cd ~/git-builds
git clone https://github.com/google/benchmark.git --depth 1
cd benchmark
mkdir -p build && cd
cmake .. -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON -DBENCHMARK_ENABLE_GTEST_TESTS=OFF
ninja && sudo checkinstall ninja install

# drake
cd ~/git-builds
git clone https://github.com/RobotLocomotion/drake.git
cd drake
git remote add upstream git@github.com:RobotLocomotion/drake.git
git remote set-url --push upstream no_push
sudo setup/ubuntu/install_prereqs.sh
bazel build
# docker pull robotlocomation/drake:latest
# cd tools/install/dockerhub/focal
# wget https://drake-packages.csail.mit.edu/drake/nightly/drake-latest-focal.tar.gz
# docker build -t robotlocomation/drake:focal

# fzf
cd ~/git-builds/
git clone https://github.com/junegunn/fzf.git
cd fzf
gvm use 16
make && checkinstall
sudo ln -s $PWD/bin/fzf ~/bin/fzf

# todoist cli
cd ~/git-builds/
git clone https://github.com/sachaos/todoist.git
cd todoist
make && checkinstall

# tikzit
cd ~/git-builds/
git clone https://github.com/tikzit/tikzit.git
sudo apt -y install flex bison qt5-default libpoppler-dev libpoppler-qt5-dev
cd tikzit
qmake -r
make
