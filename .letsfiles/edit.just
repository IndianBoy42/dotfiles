set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

lets:
    cd ~/.letsfiles/ && $EDITOR

which-editor:
    echo $EDITOR

@config:
    #!/usr/bin/env fish
    set chosen (yadm tracked ~ | fzf --preview='bat {}')
    test -n chosen && nvim $chosen

fish:
    cd $FISH_CONFIG_DIR && $EDITOR $FISH_CONFIG_PATH
    source $FISH_CONFIG_PATH

nvim: 
    cd ~/.config/nvim && $EDITOR
	
git: 
    $EDITOR ~/.gitconfig

install:
    cd ~/install-system.sh/ && $EDITOR Justfile

nix:
    cd ~/.letsfiles/ && $EDITOR nix.just
	
qmk:
    cd ~/qmk_firmware/ && $EDITOR 

kitty:
    cd ~/.config/ && $EDITOR kitty/kitty.conf
    kill -SIGUSR1 $KITTY_PID

wezterm: 
    cd ~/.config/ && $EDITOR wezterm/wezterm.lua

alacritty:
    cd ~/.config/ && $EDITOR alacritty/alacritty.yml

kmonad:
    cd ~/.config/ && $EDITOR kmonad/amedhi.kbd

broot:
    cd ~/.config/ && $EDITOR broot/conf.hjson

cargo:
    cd ~/.cargo/ && $EDITOR config.toml

aider:
    cd ~/.config && $EDITOR ~/.aider.conf.yml

tio:
    cd ~/.config && $EDITOR tio/config
