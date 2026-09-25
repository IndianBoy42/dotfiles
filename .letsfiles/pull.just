set shell := ["fish", "-c"]

wd := invocation_directory()
justrun := "just -d " + wd + " -f " + justfile()

git:
    git fetch
    git status
    confirm; and git pull --rebase

dotfiles:
    yadm fetch
    yadm status
    confirm; and yadm pull --rebase
	
