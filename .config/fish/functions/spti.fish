# Defined interactively
function spti --description 'spt with better fmt' --argument cmd
	if test (count $argv) -gt 1
		set restargs $argv[2..-1]
	end
	if test -n "$cmd"
		spt $cmd -f $SPT_FORMAT $restargs
	else
		spt
	end
end
