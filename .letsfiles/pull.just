set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

git:
    git fetch
    git status
    confirm; and git pull --rebase

nvim: 
    #!/usr/bin/env fish
    cd ~/.config/nvim
    {{justrun}} pull

dotfiles:
    yadm fetch
    yadm status
    confirm; and yadm pull --rebase
	
