#!/usr/bin/env fish

pip3 install --user qmk
cd ~
git clone --recurse-submodules https://github.com/IndianBoy42/qmk_firmware.git
sudo cp ~/qmk_firmware/util/udev/50-qmk.rules /etc/udev/rules.d/
qmk setup
qmk doctor
