#!/usr/bin/env fish
if not type -q conda
    wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O /tmp/anaconda.sh
    sh /tmp/anaconda.sh
    source ~/.bashrc
    conda update conda # in case this link is outdated
    conda update anaconda
    conda config --add channels conda-forge
    conda config --set channel_priority strict
end

pip3 install outrun xxh-xxh click argcomplete
pip3 install --user qmk

conda env create -f conda-env-*.yml
