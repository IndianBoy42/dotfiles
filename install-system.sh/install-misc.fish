#!/usr/bin/env fish

# Ultimate Plumber, live shell pipelines
cd /tmp/
wget https://github.com/akavel/up/releases/latest/download/up
mv ./up ~/bin/up

# KMonad, cross platform QMK for all keyboards 
sudo apt install input-utils evtest
wget https://github.com/david-janssen/kmonad/releases/download/0.4.1/kmonad-0.4.1-linux -O ~/bin/kmonad
chmod +x ~/bin/kmonad

sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo usermod -aG input $USER
sudo modprobe uinput
sudo touch /etc/udev/rules.d/uinput.rules
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"   (base)
  ' | sudo tee /etc/udev/rules.d/uinput.rules
  
wget https://github.com/david-janssen/kmonad/raw/master/startup/kmonad.service -O /tmp/kmonad.service
sudo cp /tmp/kmonad.service /etc/systemd/system/kmonad.service
sudo systemctl enable kmonad.service

# Wezterm -- cool terminal?
wget https://github.com/wez/wezterm/releases/download/nightly/WezTerm-nightly-Ubuntu16.04.AppImage -O ~/bin/wezterm
chmod +x ~/bin/wezterm