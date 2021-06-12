#!/usr/bin/env fish

if not type -q rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly --profile default
    rustup target add x86_64-unknown-linux-musl      
    rustup target add aarch64-unknown-linux-gnu      
    rustup target add thumbv7m-none-eabi
    rustup target add thumbv7em-none-eabi
    rustup target add thumbv7em-none-eabihf
    rustup target add aarch64-unknown-linux-musl
    rustup toolchain install stable
    rustup component add rust-analyzer-preview
else
    rustup update
end

# TODO: use quickinstall (but no native compile :/)
CARGO_BUILD_TARGET="x86_64-unknown-linux-gnu" \
    cargo install cargo-quickinstall sccache

type -q sccache && set -x RUSTC_WRAPPER (which sccache)

set -x CARGO_BUILD_TARGET "x86_64-unknown-linux-gnu"
# These cannot be compiled with musl (mostly due to OpenSSL-sys crate)
cargo install \
	alacritty \
    cargo-edit \
    cargo-generate \
    cargo-outdated \
    probe-run \
    cargo-update \
    spotify-tui \
    so \
    starship  \
    tealdeer  \
    duma  

# TODO: static install and move to Justfile
# S-tier: bat kn zoxide lsd bottom broot fd-find git-delta just ripgrep gitui
# A-tier: macchina onefetch dust hyperfine  procs ptail pueue spotify-tui tealdeer starship watchexec-cli pipe-rename
set -x CARGO_BUILD_TARGET "x86_64-unknown-linux-musl"
cargo install \
    macchina \
	onefetch \
	kn \
    bandwhich  \
    bat  \
    bottom  \
    broot  \
    cargo-binutils \
    cargo-do \
    cargo-watch \
    cargo-equip \
    drone  \
    du-dust \
    dua  \
    eva  \
    exa  \
    fd-find \
    flamegraph  \
    flip-link \
    gfold  \
    gping \
    git-delta \
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
    shy  \
    skim \
    verco  \
    watchexec-cli  \
    xsv  \
    zoxide \
    gpg-tui

cargo install --git https://github.com/IndianBoy42/gitui.git

cargo install --git https://github.com/IndianBoy42/serial-monitor.git

cargo install --git https://github.com/mosmeh/indexa.git

tldr --update

function post-cargo-install
    pip install --user alacritty-colorscheme
    wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg -O /tmp/alacritty-term.svg
    sudo cp /tmp/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info -O /tmp/alacritty.info
    sudo tic -xe alacritty,alacritty-direct /tmp/alacritty.info
    wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/linux/Alacritty.desktop -O /tmp/Alacritty.desktop
    sudo desktop-file-install /tmp/Alacritty.desktop
    sudo update-desktop-database
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator (which alacritty) 99

    sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep (which bandwhich)

    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer;
    and chmod +x ~/.local/bin/rust-analyzer

# vscode font for broot wget https://github.com/Canop/broot/raw/master/resources/icons/vscode/vscode.ttf -O ~/.local/share/fonts/vscode.ttf

    systemctl --user enable pueued.service
    and systemctl --user start pueued.service

end
