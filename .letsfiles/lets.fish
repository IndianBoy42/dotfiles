# Defined interactively
function lets
    set -l argc (count $argv)
    if count $argv > /dev/null
        # Run from a justfile if exists
        if test -e ~/.letsfiles/$argv[1].just
            just -d . --justfile ~/.letsfiles/$argv[1].just $argv[2..-1]
            return 0
        end
        # Run a script/binary if exists
        if test -x ~/.letsfiles/$argv[1]
            ~/.letsfiles/$argv[1] $argv[2..-1]
            return 0
        end
        # Run a nested script/binary if exists
        if test $argc -ge 2
           and test -x ~/.letsfiles/$argv[1]/$argv[2]
            ~/.letsfiles/$argv[1]/$argv[2] $argv[3..-1]
            return 0
        end
    end
    just -d . --justfile ~/.letsfiles/Justfile $argv
end
