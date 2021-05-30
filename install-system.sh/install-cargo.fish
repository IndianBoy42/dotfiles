#!/usr/bin/env fish

if not type -q rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly --profile default
    rustup target add x86_64-unknown-linux-musl      
    rustup target add thumbv7m-none-eabi
    rustup target add thumbv7em-none-eabi
    rustup target add thumbv7em-none-eabihf
    rustup target add aarch64-unknown-linux-musl
    rustup toolchain install stable
else
    rustup update
end

CARGO_BUILD_TARGET=x86_64-unknown-linux-gnu cargo install  \
    duma  \
	just \
    macchina \
	onefetch \
	alacritty \
	kn \
    bandwhich  \
    bat  \
    bottom  \
    broot  \
    cargo-binutils \
    cargo-do \
    cargo-edit \
    cargo-generate \
    cargo-outdated \
    cargo-update \
    cargo-watch \
    drone  \
    du-dust \
    dua  \
    eva  \
    exa  \
    fd-find \
    flamegraph  \
    flip-link \
    gfold  \
    git-delta \
    gitui  \
    huniq  \
    hyperfine  \
    just  \
    lsd  \
    mdbook  \
    mdcat  \
    pipe-rename \
    probe-run \
    procs  \
    ptail  \
    pueue  \
    ripgrep  \
    rustfilt  \
    scriptisto  \
    sd  \
    serial-monitor \
    shy  \
    skim \
    so  \
    spotify-tui \
    starship  \
    tealdeer  \
    verco  \
    watchexec-cli  \
    xsv  \
    zoxide \
    gpg-tui

CARGO_BUILD_TARGET=x86_64-unknown-linux-gnu cargo install-update --all

pip install --user alacritty-colorscheme
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg -O /tmp/alacritty-term.svg
sudo cp /tmp/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info -O /tmp/alacritty.info
sudo tic -xe alacritty,alacritty-direct /tmp/alacritty.info
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/linux/Alacritty.desktop -O /tmp/Alacritty.desktop
sudo desktop-file-install /tmp/Alacritty.desktop
sudo update-desktop-database

sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep (which bandwhich)

curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer;
and chmod +x ~/.local/bin/rust-analyzer
