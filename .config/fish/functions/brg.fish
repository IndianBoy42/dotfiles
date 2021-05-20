# Defined interactively
function brg --wraps=broot --description 'broot for git'
br --conf ~/.config/broot/git-diff.toml --git-status
end
