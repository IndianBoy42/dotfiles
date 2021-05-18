# Defined in /home/amedhi/.config/fish/config.fish @ line 131
function v
	if test -f $argv
		bat $argv
	else
		lsd -A $argv
	end
end
