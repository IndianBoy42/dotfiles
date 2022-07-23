function v
    test (count $argv) -lt 1 && lsd -A && return
    for arg in $argv
        if set -q $arg
            echo "VARIABLES: "
            set --show $arg
        end
        if type -q $arg
            echo "COMMANDS: "
            type -a $arg
        end
        if test -f $arg
            echo "FILE: "
            lsd -al $arg
            bat $arg
        end
        if test -d $arg
            echo "DIR LS: "
            lsd -A $arg
        end
        if test -L $arg
            echo "LINK: "
            lsd -al $arg
        end
    end
end
