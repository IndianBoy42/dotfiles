function tldr
command tldr --list --color always | fzf --queryy "$argv" --preview="tldr --color always {}"
end
