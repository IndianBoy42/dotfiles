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

# On Pop-os, fake distro-info (idk why)
sudo cp /usr/share/distro-info/ubuntu.csv /usr/share/distro-info/pop.csv

# Start installing all programs 
cd ~/install-system.sh/
./install-fish.sh
./install-system.fish
just add-local-repo
./install-apt-srcs.fish
./install-apt.fish
 # TODO: move to Justfile
just cmake fzf zstd kmonad git-subrepo
just go # ./install-go.fish
just node # ./install-node.fish
just conda # ./install-py.fish
just nvim # ./install-just.fish
just firacode
just rustc
just cargo-install
just julia
```

The other install scripts can be done in mostly any order. I don't even know if these scripts are in the correct order

You shouldn't do `install-misc.fish` all at once to properly monitor what commands are running

I wish Fish could be made to print the commands before they run, probably a wrapper function could work

I also wish I could install `neovim` earlier because I inevitably have to edit configs and scripts before I get to that stage
