function __reg_on_dir_change
end
function __on_dir_change --on-variable PWD
    # if test $ON_DIR_CHANGE_EN -ne 0
    #     return 0
    # end
	# TODO: dont onefetch if we are navigating around inside the repo
	set _root (git rev-parse --show-toplevel 2> /dev/null)
	if test -n "$_root"
		if test -z "$CURR_GIT_ROOT"
			onefetch --no-color-palette 2> /dev/null
		else 
			if test "$CURR_GIT_ROOT" != "$_root"
				onefetch --no-color-palette 2> /dev/null
			end
		end
	end
	set -gx CURR_GIT_ROOT "$_root"
	# if test -d .git
	# 	onefetch --no-color-palette 2> /dev/null
	# end
	lsd -A
end
