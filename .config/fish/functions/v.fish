# Defined in /tmp/fish.h2mkZA/v.fish @ line 2
function v
    test (count $argv) -lt 1 && lsd -A && return
    for arg in $argv
        if set -q $arg
            set --show $arg
        end
        if type -q $arg
            type -a $arg
        end
        if test -f $arg
            lsd -al $arg
            bat $arg
        else
            lsd -A $arg
        end
    end
end
