mkdir -p ~/bin

# just upgrade everything once
sudo apt-get dist-upgrade

# Essential
sudo apt-get install -y apt-transport-http\
    curl \
    wget \
    build-essential \
    gnupg2 \
    lsb-release

xmodmap ~/.xmodmap-capslockmod

# install from all the "package managers"
fish ~/.cargo/install-apt.fish
fish ~/.cargo/install-cargo.fish
fish ~/.cargo/install-py.fish
fish ~/.cargo/install-jl.fish
fish ~/.cargo/install-brew.fish
