mkdir -p ~/bin

sudo apt-get dist-upgrade

sudo apt-get install -y apt-transport-http\
    curl \
    wget \
    build-essential \
    gnupg2 \
    lsb-release

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

xmodmap ~/.xmodmap-capslockmod

fish ~/.cargo/install-apt.fish
fish ~/.cargo/install-cargo.fish
fish ~/.cargo/install-py.fish
fish ~/.cargo/install-jl.fish
