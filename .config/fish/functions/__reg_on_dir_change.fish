function __reg_on_dir_change
end
function __on_dir_change --on-variable PWD
    # if test $ON_DIR_CHANGE_EN -ne 0
    #     return 0
    # end

    # Try get the current git repo
	set _root (git rev-parse --show-toplevel 2> /dev/null)
	if test -n "$_root"
		if test -z "$CURR_GIT_ROOT" # Wasnt in a Git repo before
            git fetch &>/dev/null &
			onefetch --no-color-palette 2> /dev/null
		else 
			if test "$CURR_GIT_ROOT" != "$_root" # Was in a different Git repo before
                git fetch &>/dev/null &
				onefetch --no-color-palette 2> /dev/null
			end
		end
	end
	set -gx CURR_GIT_ROOT "$_root"

	lsd -A --color always --icon always --group-dirs first --timesort | head -5
end
