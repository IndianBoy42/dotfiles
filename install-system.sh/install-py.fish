#!/usr/bin/env fish
if not type -q conda
    wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O /tmp/anaconda.sh
    sh /tmp/anaconda.sh -b -u
    bass source ~/.bashrc
	conda remove anaconda --force
	conda update --all
end

conda activate base
pip3 install outrun xxh-xxh click argcomplete thefuck

for f in conda-env-*.yml
	echo $f
	conda env create -f $f || conda env update --prune -n (cat conda-env-comp-vision.yml | rg 'name: ([\S]+)' -C0 -r '$1')
end
