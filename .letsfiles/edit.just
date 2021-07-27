set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

fish:
	$EDITOR $FISH_CONFIG_PATH
	source $FISH_CONFIG_PATH

nvim: 
	cd ~/.config/nvim && $EDITOR
	
git: 
	$EDITOR ~/.gitconfig

install:
	lets install edit

nix:
	lets nix edit
	
