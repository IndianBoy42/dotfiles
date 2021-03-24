#!/usr/bin/env fish

if not test -f /tmp/code_latest_amd64.deb
	wget https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O /tmp/code_latest_amd64.deb
end
sudo dpkg -i /tmp/code_latest_amd64.deb

