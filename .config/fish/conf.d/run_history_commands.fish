if status is-interactive 
    # All these add a space before the command to make sure it doesn't get added to the history
    if false
        # Defined in /home/amedhi/.config/fish/config.fish @ line 104
        function run_history_command
            echo $history[$argv[1]] $argv[2..-1]
            eval $history[$argv[1]] $argv[2..-1]
        end
        # Defined in /home/amedhi/.config/fish/config.fish @ line 111
        function run_prev2_command
            run_history_command 2 $argv
        end
        # Defined in /home/amedhi/.config/fish/config.fish @ line 108
        function run_previous_command
            run_history_command 1 $argv
        end

        # repeat the previous command
        abbr k ' run_previous_command'
        abbr kk ' run_prev2_command'
        abbr K ' run_history_command' 
        abbr sukk ' sudo run_prev2_command'
    else
        function __replace_k_abbr  --on-event fish_postexec -d "Replaces the k abbreviation after every execution"
            # argv is the just executed commandline

            # Just repeating the old command, dont override k
            if test "$argv" = " $history[1]"
                return
            end

            # The space at the beginning means it won't be added to history, so we don't replace k either
            if string match ' *' "$argv" > /dev/null
                # This seems to be the previous command but with a space (from k) and some extra args, now we should replace k
                if not string match " $history[1]*" "$argv" > /dev/null
                    return
                end
            end

            set argv (string trim $argv)
            abbr -g k " $argv"
            abbr -g kk " $history[1]"
        end
    end
end
