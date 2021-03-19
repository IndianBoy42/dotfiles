mkdir -p ~/bin

sudo apt-get dist-upgrade

sudo apt-get install -y apt-transport-http\
    curl \
    wget \
    build-essential \
    gnupg2 \
    lsb-release

xmodmap ~/.xmodmap-capslockmod

fish ~/.cargo/install-apt.fish
fish ~/.cargo/install-cargo.fish
fish ~/.cargo/install-py.fish
fish ~/.cargo/install-jl.fish
fish ~/.cargo/install-brew.fish
