#!/usr/bin/env fish

cd ~/git-builds
git clone --depth 1 git://git.sv.gnu.org/emacs.git
cd emacs
sudo apt install libxaw7-dev libgnutls30 xaw3dg xutils-dev libgnutls28-dev libgccjit-10-dev
./autogen.sh &&\
./configure --with-native-compilation --with-modules=on &&\
make -C lisp autoloads-force &&\
make &&\
sudo checkinstall prefix=$HOME/.local/

git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
