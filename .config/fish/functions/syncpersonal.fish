# Defined in /tmp/fish.fX4BIo/syncpersonal.fish @ line 2
function syncpersonal --description 'sync some personal git repos'
	fish -c "cd ~/journal-notes/ && onefetch && git fetch && git pull && git status"
	fish -c "cd ~/Documents/optimal-control-note/ && onefetch && git fetch && git pull && git status"
	fish -c "cd ~ && yadm fetch && yadm pull && yadm status"
end
