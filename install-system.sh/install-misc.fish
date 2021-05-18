#!/usr/bin/env fish

# Ultimate Plumber, live shell pipelines
cd /tmp/
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
