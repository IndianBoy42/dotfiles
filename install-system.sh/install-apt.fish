#!/usr/bin/env fish

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
if not test -f /etc/apt/sources.list.d/sublime-text.list
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
end
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
sudo mv signal-desktop-keyring.gpg /usr/share/keyrings/

sudo add-apt-repository -y ppa:git-core/ppa
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

sudo rm /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu groovy stable"

sudo apt update

sudo apt-get install -y \
    openssh-server \
    signal-desktop \
    libopenblas-dev \
    liblapack-dev \
    libomp-dev \
    libpomp-dev \
    libeigen3-dev \
	libgtk-3-dev \
	qemu-system-arm \
	qemu-system-aarch64 \
	meson \
	gcc-arm-none-eabi \
	libglibmm-2.4-dev \
	libglib2.0-dev \
	python \
	bison \
	binutils \
	lld \
	googletest \
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
    libtiff-dev \
	libx11-dev \
	libxpm-dev \
	libgtk2.0-dev \
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
	fancontrol lm-sensors psensor sensors-applet \
    linux-tools-common linux-tools-generic linux-tools-(uname -r) \
	docker-ce docker-ce-cli containerd.io \
	musl musl-dev musl-tools \
	direnv
