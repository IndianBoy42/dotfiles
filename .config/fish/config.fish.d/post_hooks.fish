##################################
# Initialize commands
##################################

if type -q zoxide
	zoxide init fish | source
end

if type -q _kn
	_kn init fish | source
end

if type -q direnv
	direnv hook fish | source
end

if type -q cod
	cod init %self fish | source
end

# Use starship (I prefer fish tide for now)
# starship init fish | source

# alias thefuck for quick correct in the shell
#if type -q thefuck
#	status is-interactive; and thefuck --alias fk | source
#end
