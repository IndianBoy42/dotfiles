sudo apt-get dist-upgrade
sudo apt-get install -y yadm
yadm clone https://github.com/IndianBoy42/dotfiles.git

sudo apt-get install -y apt-transport-https
sudo apt-get install -y cmake ninja-build openocd
sudo apt-get install -y curl build-essential gnupg2 lsb-release

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-add-repository ppa:fish-shell/release-3
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list

sudo apt-get update

sudo apt-get install -y fish
chsh -s /usr/bin/fish
#fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
# Check if all fish plugins will be available already because of yadm

sudo apt-get install -y neovim x11-xserver-utils thefuck libudev-dev libusb-dev libcairo2-dev libjpeg-dev libgif-dev texlive-full python3-pip sublime-merge libpango1.0-dev librsvg2-dev libssl-dev libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev
sudo apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

sudo apt-get install -y clang

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fish ~/.cargo/install-cargo.sh

xmodmap ~/.xmodmap-capslockmod
wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O /tmp/anaconda.sh
sh /tmp/anaconda.sh
source ~/.bashrc
conda update conda # in case this link is outdated
conda update anaconda
conda config --add channels conda-forge
conda config --set channel_priority strict

