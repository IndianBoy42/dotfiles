set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

__choose:
    {{justrun}} --choose

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
	
kmonad:
    cd ~/.config/kmonad && $EDITOR amedhi.kbd
	
qmk:
    cd ~/qmk_firmware/ && $EDITOR indianboy42/keymap_common.h
