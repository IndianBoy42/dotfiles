function last_history_item
    echo $history[1]
end
function second_last_history_item
    echo $history[2]
end
abbr -a ! --position anywhere --function last_history_item
abbr -a k --function last_history_item
abbr -a kk --function second_last_history_item
