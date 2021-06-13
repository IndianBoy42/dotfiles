#!/usr/bin/env fish

sudo apt update

# sudo apt install autoconf-archive gnu-standards autoconf-doc bison-doc clang-12-doc cmake-doc dh-make aufs-tools \
  ffmpeg-doc gettext-doc libasprintf-dev libgettextpo-dev \
  extra-xdg-menus kicad-doc-en kicad-packages3d libasound2-doc libbluray-bdj libcairo2-doc libdatrie-doc \
  libeigen3-doc libmpfrc++-dev libfftw3-bin libfftw3-dev freetype2-doc glew-utils \
  libgirepository1.0-dev libglib2.0-doc libglibmm-2.4-doc libgtkmm-3.0-dev libgraphite2-utils \
  libgtk-3-doc libgtk2.0-doc libice-doc liblapack-doc libtool-doc liblzma-doc ncurses-doc \
  libnewlib-doc libomp-12-doc libportaudio2 libpango1.0-doc librsvg2-doc \
  libsigc++-2.0-doc libsm-doc sndiod sordi gstreamer1.0-libav gstreamer1.0-plugins-ugly libssl-doc \
  libthai-doc gfortran fortran95-compiler gcj-jdk libwayland-doc libx11-doc libxcb-doc libxext-doc \
  libxt-doc llvm-12-doc read-edid i2c-tools m4-doc ctags vim-scripts molly-guard monkeysphere \
  ssh-askpass pandoc-citeproc \
  wkhtmltopdf librsvg2-bin \
  libjs-mathjax citation-style-language-styles python-tk \
  python-greenlet-doc python-greenlet-dev python3-greenlet-dbg python-pil-doc \
  python3-pil-dbg python-pygments-doc ttf-bitstream-vera python-setuptools-doc wx3.0-doc \
  python3.9-venv python3.9-doc samba vde2 sharutils-doc \
  libjpeg-progs zathura-ps zathura-djvu zathura-cb

sudo apt install (cat libs.apt)
sudo apt install linux-tools-(uname -r)
sudo apt install (cat apps.apt)

