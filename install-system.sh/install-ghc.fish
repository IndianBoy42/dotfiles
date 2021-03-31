#!/usr/bin/env fish

if not type -q ghcup
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
else
    ghcup
end
if not type -q stack
    curl -sSL https://get.haskellstack.org/ | sh
else
    stack upgrade
end

cd ~/git-builds/
git clone --depth https://github.com/diku-dk/futhark.git
cd futhark
stack setup
stack build
stack install


