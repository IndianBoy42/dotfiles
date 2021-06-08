#!/usr/bin/env fish

if not test -f /tmp/code_latest_amd64.deb
	wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O /tmp/code_latest_amd64.deb
end
sudo dpkg -i /tmp/code_latest_amd64.deb
rm /tmp/code_latest_amd64.deb
sudo ln -s /usr/share/code/bin/code /usr/local/bin

function code-portable-installer
    cd /tmp/
    mkdir -p vscodeportable
    cd vscodeportable
    wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" -O portable.tar.gz
    tar -xzf portable.tar.gz
    mkdir -p ~/portable/vscode
    cp -r VSCode-linux-x64/* ~/portable/vscode/
    ln -s ~/portable/vscode/bin/code ~/.local/bin/code-portable
end
