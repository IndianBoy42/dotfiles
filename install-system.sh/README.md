# Order of operation

```
# Install YADM and pull my dotfiles
# Use a temporary yadm to clone the dotfiles
# curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
  && chmod +x /tmp/yadm \
  && /tmp/yadm clone https://github.com/IndianBoy42/dotfiles.git
# Use official bootstrap script
curl -L bootstrap.yadm.io | bash -s -- https://github.com/IndianBoy42/dotfiles.git

# Install all the alternatives
yadm config local.class {Laptop|Desktop} && yadm alt

# Start installing all programs
cd ~/install-system.sh/
./install-system.sh

## REBOOT

# just add-local-repo # if have
./install-apt-srcs.fish
./install-apt.fish
just stow
just cmake fzf zstd kmonad git-subrepo
just go
just node
just conda
just nvim
just firacode
just rustc
just cargo-install
just julia
```

The other install scripts can be done in mostly any order. I don't even know if these scripts are in the correct order

You shouldn't do `install-misc.fish` all at once to properly monitor what commands are running

I wish Fish could be made to print the commands before they run, probably a wrapper function could work

I also wish I could install `neovim` earlier because I inevitably have to edit configs and scripts before I get to that stage

# TODO:

I should use nix for more tools, instead of apt
