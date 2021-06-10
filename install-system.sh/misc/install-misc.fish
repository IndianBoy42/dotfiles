#!/usr/bin/env fish

# dont run as root
if test (id -u) -eq 0
    exit 1
end

# gcc-arm-none-eabi (newer than apt)
mkcd /tmp/armgcc
gh release -R xpack-dev-tools/arm-none-eabi-gcc-xpack download -p '*linux-x64.tar.gz'
tar xaf *.tar.gz
mv xpack-arm-*/ ~/.local/arm-none-eabi-gcc
ln -s $HOME/.local/arm-none-eabi-gcc/bin ~/.local/bin

# make sure this is installed and use it for source builds
sudo apt install checkinstall
mkdir -p ~/git-builds
cd ~/git-builds

# Ultimate Plumber, live shell pipelines 
cd /tmp/
gh release -R akavel/up download -p 'up'
mv /tmp/up ~/.local/bin/up
chmod +x ~/.local/bin/up

# Wezterm -- cool terminal?
cd /tmp/wezterm
gh release -R wez/wezterm download -p '*.AppImage'
mv /tmp/wezterm/*.AppImage ~/.local/bin/wezterm
chmod +x ~/.local/bin/wezterm
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (which wezterm) 90

# kitty terminal
cd ~/git-builds/
wget https://sw.kovidgoyal.net/kitty/installer.sh -O /tmp/kitty-installer.sh
sudo checkinstall sh -c /tmp/kitty-installer.sh
ln -s $HOME/.local/kitty.app/bin/kitty ~/.local/bin/

# Zenith -- better top
mkcd /tmp/zenith
gh release -R bvaisvil/zenith download -p '*amd64.deb'
sudo dpkg -i ./*.deb

# PathPicker -- terminal path picker
cd ~/git-builds/
git clone https://github.com/facebook/PathPicker --depth 1
cd PathPicker/debian
sh ./package.sh
sudo dpkg -i ../*.deb

# cod -- completion learning daemon
# remember to activate go: gvm use 16
go get -u github.com/dim-an/cod

# gnome-quake
# go to https://extensions.gnome.org/extension/1411/quake-mode/

# localtunnel
npm install -g localtunnel

# nnn - not that, its a file manager
echo 'deb http://download.opensuse.org/repositories/home:/stig124:/nnn/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:stig124:nnn.list
curl -fsSL https://download.opensuse.org/repositories/home:stig124:nnn/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stig124_nnn.gpg > /dev/null
sudo apt update
sudo apt install nnn

# tinycc compiler
cd ~/git-builds/
git clone https://github.com/TinyCC/tinycc.git
cd tinycc
./configure --extra-cflags='-O3 -march=native -mtune=native' --extra-ldflags='-march=native -mtune=native' --cc=clang-12; 
and make;
and sudo checkinstall

# keynav
cd ~/git-builds/
git clone --depth 1 https://github.com/jordansissel/keynav.git
cd keynav
make && sudo checkinstall

# zig compiler
cd ~/git-builds/
git clone https://github.com/ziglang/zig.git --depth 1
sudo apt install libllvm12 libclang-12-dev liblld-12-dev
cd zig
mkdir build;
and cd build;
and cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DZIG_TARGET_MCPU=native ..;
and checkinstall ninja install

# indexa
cd ~/git-builds
git clone https://github.com/mosmeh/indexa.git --depth 1
cd index
cargo install --path .

# godbolt
cd ~/git-builds
git clone https://github.com/compiler-explorer/comp
iler-explorer.git
cargo install rustfilt

# zapcc
# !! This must only be done manually it takes so much gd RAM and Disk
# cd ~/git-builds
# git clone https://github.com/yrnkrn/zapcc.git
# cmake -DLLVM_ENABLE_WARNINGS -DLLVM_USE_LINKER=gold ..

# google benchmark
cd ~/git-builds
git clone https://github.com/google/benchmark.git --depth 1
cd benchmark
mkdir -p build && cd
cmake .. -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON -DBENCHMARK_ENABLE_GTEST_TESTS=OFF
ninja && sudo checkinstall ninja install

# drake
# cd ~/git-builds
# git clone https://github.com/RobotLocomotion/drake.git
# cd drake
# git remote add upstream git@github.com:RobotLocomotion/drake.git
# git remote set-url --push upstream no_push
# sudo setup/ubuntu/install_prereqs.sh
# bazel build
# docker pull robotlocomation/drake:latest
# cd tools/install/dockerhub/focal
# wget https://drake-packages.csail.mit.edu/drake/nightly/drake-latest-focal.tar.gz
# docker build -t robotlocomation/drake:focal

# todoist cli
cd ~/git-builds/
git clone https://github.com/sachaos/todoist.git
cd todoist
make && sudo checkinstall

# tikzit
cd ~/git-builds/
git clone https://github.com/tikzit/tikzit.git
sudo apt -y install flex bison qt5-default libpoppler-dev libpoppler-qt5-dev
cd tikzit
qmake -r
make

# clifm
mkcd /tmp/clifm
gh release -R leo-arch/clifm download -p '*deb'
sudo apt install libcap-dev libacl1-dev libreadline-dev
sudo dpkg -i *deb

# install jupyter
conda install jupyter 

# install mps-youtube
pipx install git+https://github.com/mps-youtube/mps-youtube.git
pipx inject mps-youtube youtube-dl 
pipx inject mps-youtube pyperclip
sudo add-apt-repository -y ppa:mc3man/mpv-tests
sudo apt-get update
sudo apt install mpv

# Helpers with ssh-ing and remote computers
pipx install outrun
pipx install xxh-xxh
pip3 install --user click argcomplete 

# Futhark
cd ~/git-builds/
git clone --depth 1 https://github.com/diku-dk/futhark.git
cd futhark
stack setup
stack build
stack install

# Ansi aware column command
curl -sL http://cpanmin.us | sudo perl - App::ansicolumn
