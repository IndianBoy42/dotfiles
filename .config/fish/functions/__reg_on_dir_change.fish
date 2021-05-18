function __reg_on_dir_change
	__save_post_exec_dir_fn
	__save_pre_exec_dir_fn
end
function __on_dir_change --on-event fish_prompt
	if [ $__save_post_exec_dir != $__save_pre_exec_dir ]
		# TODO: dont onefetch if we are navigating around inside the repo
		if test -d .git
			onefetch --no-color-palette 2> /dev/null
		end
		lsd -A
	end
end
function __save_post_exec_dir_fn --on-event fish_postexec
set -gx __save_post_exec_dir $PWD
end
function __save_pre_exec_dir_fn --on-event fish_preexec
set -gx __save_pre_exec_dir $PWD
end
