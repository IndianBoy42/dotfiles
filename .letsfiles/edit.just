set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

lets:
    cd ~/.letsfiles/ && $EDITOR

edit:
    cd ~/.letsfiles/ && $EDITOR edit.just

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

jj:
    cd ~/.config/jj && $EDITOR ./config.toml

install:
    cd ~/install-system.sh/ && $EDITOR Justfile

nix:
    cd ~/.letsfiles/ && $EDITOR nix.just
	
qmk:
    cd ~/qmk_userspace/ && $EDITOR 

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

opencode:
    cd ~/.config/opencode && $EDITOR ./opencode.jsonc
oc: opencode

tio:
    cd ~/.config && $EDITOR tio/config

dotenv:
    $EDITOR ~/.env && envsource ~/.env

smerge:
    cd ~/.config/ && $EDITOR ~/.config/sublime-merge/config.yml ~/.config/sublime-merge/.sublime-keymap

flash:
    cd ~/.letsfiles/ && $EDITOR flash.just
