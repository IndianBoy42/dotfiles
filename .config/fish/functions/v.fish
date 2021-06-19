# Defined in /tmp/fish.RDtX7K/v.fish @ line 2
function v
    test (count $argv) -lt 1 && lsd -A && return
    for arg in $argv
        if set -q $arg
            set --show $arg
        else if test -f $arg
            lsd -al $arg
            bat $arg
        else
            lsd -A $arg
        end
    end
end
