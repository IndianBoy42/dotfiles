cat ~/.cargo/.crates.toml | rg -C0 '^"([\w-]+?) .*git.*' -r 'cargo install $1'
echo "cargo install-update"
