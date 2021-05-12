#!/usr/bin/env sh
# This probably will need to be run separately

sudo apt-get install yadm

wget https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.394-beta/gcmcore-linux_amd64.2.0.394.50751.deb -O /tmp/gcmcore.deb
sudo dpkg -i /tmp/gcmcore.deb
git-credential-manager-core configure
git config --global credential.credentialStore secretservice # requires GUI (ok?)

yadm clone https://github.com/IndianBoy42/dotfiles.git
