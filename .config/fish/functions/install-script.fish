# Defined in /home/amedhi/.config/fish/config.fish @ line 78
function install-script
	set file ~/install-system.sh/install-$argv.fish
	set tmpfile /(mktemp)
	cp $file $tmpfile
	$EDITOR $file
	delta $tmpfile $file
end
