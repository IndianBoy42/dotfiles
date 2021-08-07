set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

__choose:
    {{justrun}} --choose

fish:
	$EDITOR $FISH_CONFIG_PATH
	source $FISH_CONFIG_PATH

nvim: 
	cd ~/.config/nvim && $EDITOR
	
git: 
	$EDITOR ~/.gitconfig

install:
	$EDITOR ~/install-system.sh/Justfile

nix:
	$EDITOR ~/.letsfiles/nix.just
	
qmk:
    $EDITOR ~/qmk_firmware/indianboy42/keymap_common.h
