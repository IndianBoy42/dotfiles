#!/usr/bin/env fish

function nf-install-helper
mkdir -p /tmp/fonts
echo "[-] Download fonts [-]"
echo "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$argv.zip"
set tmpfile (mktemp)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$argv.zip -O $tmpfile && unzip $tmpfile -d ~/.fonts
fc-cache -fv
echo "done!"
end

nf-install-helper FiraCode
nf-install-helper FiraMono
