# Defined in /home/amedhi/.config/fish/config.fish @ line 212
function touchp
	mkdir -p (dirname $argv)
	touch $argv
end
