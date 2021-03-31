#!/usr/bin/env fish

sudo apt install input-utils evtest
wget https://github.com/david-janssen/kmonad/releases/download/0.4.1/kmonad-0.4.1-linux -O ~/bin/kmonad

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

