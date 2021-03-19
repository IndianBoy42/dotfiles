#!/usr/bin/env sh
if not type -q rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
end

cargo install /
    duma /
    bandwhich /
    bat /
    bottom /
    broot /
    cargo-binutils/
    cargo-do/
    cargo-edit/
    cargo-generate/
    cargo-outdated/
    cargo-update/
    cargo-watch/
    drone /
    du-dust/
    dua /
    eva /
    exa /
    fd-find/
    flamegraph /
    flip-link/
    gfold /
    git-delta/
    gitui /
    huniq /
    hyperfine /
    just /
    lsd /
    mdbook /
    mdcat /
    pipe-rename/
    probe-run/
    procs /
    ptail /
    pueue /
    ripgrep /
    rustfilt /
    scriptisto /
    sd /
    serial-monitor/
    shy /
    so /
    spotify -tui/
    starship /
    tealdeer /
    verco /
    watchexec /
    xsv /
    zoxide 

cargo install-update --all
