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

qmk:
    cd ~/qmk_userspace/ && $EDITOR 

kitty:
    cd ~/.config/ && $EDITOR kitty/kitty.conf
    kill -SIGUSR1 $KITTY_PID

cargo:
    cd ~/.cargo/ && $EDITOR config.toml

oh-my-pi:
    cd ~/.omp/ && $EDITOR ./agent/config.yml
omp: oh-my-pi

tio:
    cd ~/.config && $EDITOR tio/config

dotenv:
    $EDITOR ~/.env && envsource ~/.env

flash:
    cd ~/.letsfiles/ && $EDITOR flash.just

fedora:
    cd ~/.letsfiles/ && $EDITOR fedora.just
