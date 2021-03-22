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

conda activate base
pip3 install outrun xxh-xxh click argcomplete thefuck
pip3 install --user qmk

for f in conda-env-*.yml
	echo $f
	conda env create -f $f || conda env update --prune -n (cat conda-env-comp-vision.yml | rg 'name: ([\S]+)' -C0 -r '$1')
end
