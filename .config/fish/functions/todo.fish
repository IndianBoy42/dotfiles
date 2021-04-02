function todo
    if not type -q todoist
        gvm use 16
    end
    todoist sync
    todoist $argv
end
