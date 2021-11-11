set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

git:
    git fetch
    git status
    confirm; and git pull --rebase

fish:
    cd $FISH_CONFIG_DIR && $EDITOR $FISH_CONFIG_PATH
    source $FISH_CONFIG_PATH

nvim: 
    #!/usr/bin/env fish
    cd ~/.config/nvim
    {{justrun}} pull

dotfiles:
    yadm fetch
    yadm status
    confirm; and yadm pull --rebase

nix:
    cd ~/.letsfiles/ && $EDITOR nix.just
	
kmonad:
    cd ~/.config/kmonad && $EDITOR amedhi.kbd
	
qmk:
    cd ~/qmk_firmware/ && $EDITOR indianboy42/keymap_common.h

@config:
    #!/usr/bin/env fish
    set chosen (yadm tracked ~ | fzf --preview='bat {}')
    test -n chosen && nvim $chosen

