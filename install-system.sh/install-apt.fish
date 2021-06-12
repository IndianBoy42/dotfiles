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


sudo apt-get install \
	libusb-1.0-0-dev libgpg-error-dev libgpgme-dev \
    libcairo2-dev libxinerama-dev libxdo-dev \
    libopenblas-dev liblapack-dev libomp-dev \
    libpomp-dev libeigen3-dev libgtk-3-dev \
	libasound2-dev libtool-bin libtool \
	libglibmm-2.4-dev libglib2.0-dev \
    libudev-dev libusb-dev libjpeg-dev \
    libgif-dev libtiff-dev libx11-dev \
	libxpm-dev libgtk2.0-dev libpango1.0-dev \
    librsvg2-dev libssl-dev libxcb1-dev \
    libxcb-render0-dev libxcb-shape0-dev \
    libxcb-xfixes0-dev libgl1-mesa-glx \
    libegl1-mesa libxrandr2 libxss1 \
    libxcursor1 libxcomposite1 libasound2 \
    libxi6 libxtst6 freeglut3-dev \
    aptitude \
	alacritty \
	ripgrep \
	checkinstall \
    imagemagick \
    openssh-server \
	qemu-system-arm qemu-system-aarch64 \
	meson \
	gcc-arm-none-eabi \
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
	bison \
	binutils lld ninja-build \
    openocd \
    zathura \
    x11-xserver-utils \
	python python3-pip python3-venv \
    sublime-merge \
    sshpass \
    google-chrome-stable \
    ffmpeg \
	fancontrol lm-sensors psensor sensors-applet \
    linux-tools-common linux-tools-generic linux-tools-(uname -r) \
	musl musl-dev musl-tools \
	direnv \
	screen tmux \
	pandoc progress \
	archivemount sshfs \
    suckless-tools sxiv xdotool \
    gh gnupg ca-certificates ranger
