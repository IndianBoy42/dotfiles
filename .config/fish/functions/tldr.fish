function tldr
    set name (command tldr --list --color always | fzf --query "$argv" --preview="command tldr --color always {}")
    and command tldr $name
end
