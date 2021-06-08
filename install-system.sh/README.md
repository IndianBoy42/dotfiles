# Order of operations

```
# Install YADM and pull my dotfiles
wget {install_yadm.sh} && chmod +x install_yadm.sh && ./install_yadm.sh
yadm config local.class {Laptop|Desktop} && yadm alt
# On Pop-os, fake distro-info (idk why)
sudo cp /usr/share/distro-info/ubuntu.csv /usr/share/distro-info/pop.csv

cd ~/install-system.sh/
./install-fish.sh
./install-system.fish
./install-fonts.fish
./install-git.fish
./install-apt-srcs.fish
./install-apt.fish
./install-essential.fish
./install-go.fish
./install-node.fish
./install-py.fish
./install-nvim.fish
./install-cargo.fish
./install-jl.fish
```

The other install scripts can be done in different orders

You shouldn't do `install-misc.fish` all at once to properly monitor what commands are running

I wish Fish could be made to print the commands before they run, probably a wrapper function could work
