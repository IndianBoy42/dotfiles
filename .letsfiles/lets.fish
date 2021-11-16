# Defined interactively
function lets
    set -l argc (count $argv)
    if count $argv >/dev/null
        # Run from a justfile if exists
        if test -e ~/.letsfiles/$argv[1].just
            just -d . --justfile ~/.letsfiles/$argv[1].just $argv[2..-1]
            return 0
        end
        # Run a nested script/binary if exists
        set -l nested ~/.letsfiles/$argv[1]/$argv[2]*
        if test $argc -ge 2
            and test -n "$nested"
            and test -x "$nested"
            $nested $argv[3..-1]
            return 0
        end
        # Run a script/binary if exists
        set -l script ~/.letsfiles/$argv[1]*
        if test -n "$script"
            and test -x "$script"
            $script $argv[2..-1]
            return 0
        end
    end
    just -d . --justfile ~/.letsfiles/Justfile $argv
end
