# Defined in /home/amedhi/.config/fish/config.fish @ line 185
function zh
	cd (dirh | fzf --tac | sd '\s*[0-9]+\)\s*(.*)' '$1')
end
