function todov
    todoist show (todoist $argv | fzf | rg "([0-9]+)\s.*\$" -r "\$1")
end
