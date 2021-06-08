#!/usr/bin/env fish

# dont run as root
if test (id -u) -eq 0
    exit 1
end

# cmake
mkcd /tmp/cmake
gh release -R Kitware/CMake download -p '*linux-x86_64.tar.gz'
tar xaf *.tar.gz
mv cmake*/ ~/.local/cmake
ln -s $HOME/.local/cmake/bin ~/.local/bin

# fzf
# go get -u 'github.com/junegunn/fzf'
mkcd /tmp/fzf
gh release -R junegunn/fzf download -p '*linux_amd64.tar.gz'
tar xaf *.tar.gz
mv fzf ~/.local/bin

# zstd
cd /tmp/
gh release -R facebook/zstd download -p '*.tar.gz'
tar xf --directory=~/git-builds/zstd
and cd ~/git-builds/zstd
and make
and ln -s (realpath zstd) ~/.local/bin/zstd

# KMonad, cross platform QMK for all keyboards 
sudo apt install input-utils evtest
mkcd /tmp/kmonad
gh release -R kmonad/kmonad download -p '*linux'
mv ./*linux ~/.local/bin/kmonad
chmod +x ~/.local/bin/kmonad

sudo groupadd uinput
sudo usermod -aG uinput $USER
sudo usermod -aG input $USER
sudo modprobe uinput
sudo touch /etc/udev/rules.d/uinput.rules
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/uinput.rules
echo "The next output will help you find the device that your keyboard corresponds to"
cat /proc/bus/input/devices | rg -C5 keyboard

sudo cp ./kmonad.service /etc/systemd/user/kmonad.service

sudo systemctl enable kmonad.service

# git-subrepo
cd ~/git-builds
git clone https://github.com/ingydotnet/git-subrepo

# tectonic
# sudo apt install texlive-full
mkcd /tmp/tectonic
gh release -R tectonic-typesetting/tectonic download -p '*x86_64-unknown-linux-gnu.tar.gz'
tar xaf *.deb
mv tectonic ~/.local/bin
