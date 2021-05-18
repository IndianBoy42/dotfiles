# Defined in /home/amedhi/.config/fish/config.fish @ line 356
function watch-script
	watchexec -c -w $argv[1] "$argv[1]"
end
