#!/usr/bin/env fish

function nf-install-helper
    echo "[-] Download font ($argv) [-]"

    mkdir -p ~/Downloads/fonts
    cd ~/Downloads/fonts

    set fontfilename "$argv.zip"

    # set link "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$argv.zip"
    # echo "$link"
    # wget $link -O $fontfilename
    cd ~/Downloads/fonts
    gh release -R ryanoasis/nerd-fonts download -p $fontfilename

    and unzip $fontfilename -d ~/.fonts

    echo "done!"
end

nf-install-helper FiraCode
nf-install-helper Hack
nf-install-helper FiraMono

fc-cache -fv

