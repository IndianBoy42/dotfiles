#!/usr/bin/env fish

# Ultimate Plumber, live shell pipelines cd /tmp/
wget https://github.com/akavel/up/releases/latest/download/up
mv ./up ~/bin/up

# KMonad, cross platform QMK for all keyboards 
sudo apt install input-utils evtest
wget https://github.com/kmonad/kmonad/releases/download/0.4.1/kmonad-0.4.1-linux -O ~/bin/kmonad
chmod +x ~/bin/kmonad

sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo usermod -aG input $USER
sudo modprobe uinput
sudo touch /etc/udev/rules.d/uinput.rules
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/uinput.rules
echo "the next output will help you find the device that your keyboard corresponds to"
cat /proc/bus/input/devices | rg -C5 keyboard
  
sudo cp ./kmonad.service /etc/systemd/system/kmonad.service
sudo systemctl enable kmonad.service

# Wezterm -- cool terminal?
wget https://github.com/wez/wezterm/releases/download/nightly/WezTerm-nightly-Ubuntu16.04.AppImage -O ~/bin/wezterm
chmod +x ~/bin/wezterm

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
gvm use 16
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
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
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
make && checkinstall
