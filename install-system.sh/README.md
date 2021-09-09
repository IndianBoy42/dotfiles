# Order of operation

```
# Install YADM and pull my dotfiles
# Use a temporary yadm to clone the dotfiles
# curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
  && chmod +x /tmp/yadm \
  && /tmp/yadm clone https://github.com/IndianBoy42/dotfiles.git
# Use official bootstrap script
source <(curl -L bootstrap.yadm.io)
yadm clone https://github.com/IndianBoy42/dotfiles.git
curl -L bootstrap.yadm.io | bash -s -- https://github.com/IndianBoy42/dotfiles.git

# Install all the alternatives
yadm config local.class {Laptop|Desktop} && yadm alt

# Start installing all programs
cd ~/install-system.sh/
./install-system.sh

## REBOOT

# just add-local-repo # if have
./install-apt-srcs.fish
lets nix install-user
just apt-libs
just apt-apps
just firacode
just stow
just cmake fzf zstd kmonad git-subrepo
just go
just node
just pydev # conda
just nvim
just rustc
just cargo-all
just julia
```

I wish I could install `neovim` earlier because I inevitably have to edit configs and scripts before I get to that stage

# TODO:

I should use nix for more tools, instead of apt
