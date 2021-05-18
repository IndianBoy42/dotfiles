# Defined in /home/amedhi/.config/fish/config.fish @ line 351
function scrnew
	scriptisto new $argv[1] > $argv[2]
	chmod +x $argv[2]
	lsd -Al $argv[2]
end
