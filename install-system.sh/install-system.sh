sudo apt-get dist-upgrade

sudo apt-get install -y apt-transport-http\
    curl \
    wget \
    build-essential \
    gnupg2 \
    lsb-release

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-add-repository ppa:fish-shell/release-3
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list

sudo apt-get update

source ~/.install-fish.sh

fish ~/.cargo/install-apt.sh
fish ~/.cargo/install-cargo.sh

pip3 install outrun

xmodmap ~/.xmodmap-capslockmod

if not type -q conda
    wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O /tmp/anaconda.sh
    sh /tmp/anaconda.sh
    source ~/.bashrc
    conda update conda # in case this link is outdated
    conda update anaconda
    conda config --add channels conda-forge
    conda config --set channel_priority strict
end

