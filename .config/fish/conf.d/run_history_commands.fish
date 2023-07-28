if status is-interactive
    function __replace_k_abbr --on-event fish_postexec -d "Replaces the k abbreviation after every execution"
        # argv is the just executed commandline
        set argv (string trim $argv)

        # Just repeating the old command, dont override k
        if test "$argv" = "$history[1]"
            return
        end
        abbr -g k "$argv"
        abbr -g kk "$history[1]"
        abbr -g rr "set prevout ($argv)
and"
    end
end
