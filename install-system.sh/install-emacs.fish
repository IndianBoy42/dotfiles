#!/usr/bin/env fish

cd ~/git-builds
git clone --depth 1 git://git.sv.gnu.org/emacs.git
cd emacs
sudo apt install -y libxaw7-dev libgnutls30 xaw3dg xutils-dev libgnutls28-dev
./autogen.sh && ./configure && make
make install prefix=~/.local/
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
