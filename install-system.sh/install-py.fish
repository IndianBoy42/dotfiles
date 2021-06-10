#!/usr/bin/env fish
if not type -q conda
    wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O /tmp/anaconda.sh
    sh /tmp/anaconda.sh -b -u

    eval /home/amedhi/anaconda3/bin/conda "shell.fish" "hook" $argv | source
	# conda remove anaconda --force
    # conda update anaconda python pip
    conda update -n base -c defaults conda
	# conda update --all
    conda config --add channels conda-forge
end

pip3 install --user click argcomplete 

sudo apt install python3-pip python3-venv
pip3 install --user pipx
pipx ensurepath
pipx install pipenv

conda activate base # install this stuff to the base environment
conda install jupyter pip

for f in conda-env-*.yml
	echo $f
	conda env create -f $f || conda env update --prune -n (cat conda-env-comp-vision.yml | rg 'name: ([\S]+)' -C0 -r '$1')
end
