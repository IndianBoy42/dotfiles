# Defined interactively
function lets
    if count $argv > /dev/null
        # Run from a justfile if exists
        if test -e ~/.letsfiles/$argv[1].just
            just --justfile ~/.letsfiles/$argv[1].just $argv[2..-1]
            return 0
        end
        # Run a script/binary if exists
        if test -x ~/.letsfiles/$argv[1]
            cd ~ && ~/.letsfiles/$argv[1] $argv[2..-1]
            return 0
        end
        # Run a nested script/binary if exists
        if test -x ~/.letsfiles/$argv[1]/$argv[2]
            cd ~ && ~/.letsfiles/$argv[1]/$argv[2] $argv[3..-1]
            return 0
        end
    end
    just --justfile ~/.letsfiles/Justfile $argv
end
