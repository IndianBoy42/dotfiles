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
    zoxide 

CARGO_BUILD_TARGET=x86_64-unknown-linux-gnu cargo install-update --all

pip install --user alacritty-colorscheme

