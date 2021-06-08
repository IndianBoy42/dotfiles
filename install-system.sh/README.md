# Order of operations

```
# Install YADM and pull my dotfiles
wget {install_yadm.sh} && chmod +x install_yadm.sh && ./install_yadm.sh
# Install Fish Shell
cd ~/install-system.sh/
./install-fish.sh
./install-system.fish
./install-git.fish
./install-apt-srcs.fish
./install-apt.fish
```

The other install scripts can be done in different orders

You shouldn't do `install-misc.fish` all at once to properly monitor what commands are running

I wish Fish could be made to print the commands before they run, probably a wrapper function could work
