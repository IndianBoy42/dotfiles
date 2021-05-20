function __reg_on_dir_change
end
function __on_dir_change --on-variable PWD
	# TODO: dont onefetch if we are navigating around inside the repo
	if test -d .git
		onefetch --no-color-palette 2> /dev/null
	end
	lsd -A
end
