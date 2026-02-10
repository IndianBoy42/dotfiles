function __park
    set --local cmd (commandline)
    set --local cursor (commandline --cursor)
    commandline --replace ""

    function __unpark --inherit-variable cmd --inherit-variable cursor --on-event fish_postexec
        functions --erase __unpark
        commandline --replace $cmd
        commandline --cursor $cursor
    end
end

bind --mode default "alt-p" __park
bind --mode insert "alt-p" __park
