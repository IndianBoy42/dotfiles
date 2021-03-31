#!/usr/bin/env fish

if not type -q stack
    curl -sSL https://get.haskellstack.org/ | sh
else
    stack upgrade
end

cd ~/git-builds/
git clone https://github.com/diku-dk/futhark.git
cd futhark
git pull
stack setup
stack build
stack install


