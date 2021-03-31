#!/usr/bin/env fish

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (which alacritty) 90
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (which wezterm) 99
xdg-mime default zathura.desktop application/pdf 
