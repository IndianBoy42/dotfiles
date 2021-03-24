#!/usr/bin/env fish

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

if not test -f /etc/apt/sources.list.d/sublime-text.list
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
end

sudo apt update

sudo apt-get install -y \
    libopenblas-dev \
    liblapack-dev \
    libomp-dev \
    libeigen3-dev \
	qemu-system-arm \
	qemu-system-aarch64 \
	meson \
	bison \
	binutils \
	lld \
    cmake \
    ninja-build \
    openocd \
    zathura \
    sublime-merge \
    neovim \
    x11-xserver-utils \
    libudev-dev \
    libusb-dev \
    libcairo2-dev \
    libjpeg-dev \
    libgif-dev \
    texlive-full \
    python3-pip \
    sublime-merge \
    libpango1.0-dev \
    librsvg2-dev \
    libssl-dev \
    libxcb1-dev \
    libxcb-render0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxrandr2 \
    libxrandr2 \
    libxss1 \
    libxcursor1 \
    libxcomposite1 \
    libasound2 \
    libxi6 \
    libxtst6 \
    clang \
    libclang-dev \
    meson \
    sshpass \
    google-chrome-stable \
    kicad \
    ffmpeg \
	fancontrol lm-sensors psensor sensors-applet

