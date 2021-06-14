# Defined in /home/amedhi/.config/fish/config.fish @ line 96
if type -q pueue
    function silent
        pueue add "$argv"
    end
else 
    function silent
        $argv &> /dev/null &
    end
end
