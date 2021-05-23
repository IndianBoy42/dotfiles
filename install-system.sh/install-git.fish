#!/usr/bin/fish env

mkdir -p ~/git-builds

# git-subrepo
cd ~/git-builds
git clone https://github.com/ingydotnet/git-subrepo

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
cd ~/git-builds
git clone https://github.com/RobotLocomotion/drake.git
cd drake
git remote add upstream git@github.com:RobotLocomotion/drake.git
git remote set-url --push upstream no_push
sudo setup/ubuntu/install_prereqs.sh
bazel build
# docker pull robotlocomation/drake:latest
# cd tools/install/dockerhub/focal
# wget https://drake-packages.csail.mit.edu/drake/nightly/drake-latest-focal.tar.gz
# docker build -t robotlocomation/drake:focal

# fzf
cd ~/git-builds/
git clone https://github.com/junegunn/fzf.git
cd fzf
gvm use 16
make && checkinstall
sudo ln -s $PWD/bin/fzf ~/bin/fzf

# todoist cli
cd ~/git-builds/
git clone https://github.com/sachaos/todoist.git
cd todoist
make && checkinstall

# tikzit
cd ~/git-builds/
git clone https://github.com/tikzit/tikzit.git
sudo apt -y install flex bison qt5-default libpoppler-dev libpoppler-qt5-dev
cd tikzit
qmake -r
make
