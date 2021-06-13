# Defined in /home/amedhi/.config/fish/config.fish @ line 221
function rga-fzf-broken
	set RG_PREFIX "rga --files-with-matches"
	set file (
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	) 
	and echo "opening $file"
	and xdg-open "$file"
end
