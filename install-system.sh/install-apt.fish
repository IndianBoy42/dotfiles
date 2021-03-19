#!/usr/bin/env fish

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61


if not test -f /etc/apt/sources.list.d/sublime-text.list
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
end
if not test -f /etc/apt/sources.list.d/anydesk-stable.list
    echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
end
if not test -f /etc/apt/sources.list.d/zig.list
    echo 'deb https://dl.bintray.com/dryzig/zig-ubuntu groovy main' | sudo tee -a /etc/apt/sources.list.d/zig.list
end

sudo apt update

sudo apt-get install -y \
    cmake \
    ninja-build \
    openocd\
    sublime-merge \
    anydesk \
    neovim \
    x11-xserver-utils \
    thefuck \
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
    ffmpeg
