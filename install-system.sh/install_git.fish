#!/usr/bin/env sh

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch="(dpkg --print-architecture)" signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt install gh

mkcd /tmp/gcmcore
gh releases -R microsoft/Git-Credential-Manager-Core download -p '*amd64*.deb'
# wget https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.394-beta/gcmcore-linux_amd64.2.0.394.50751.deb -O /tmp/gcmcore.deb
sudo dpkg -i *.deb
git-credential-manager-core configure
git config --global credential.credentialStore secretservice # requires GUI (ok?)
