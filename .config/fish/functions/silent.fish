if type -q pueue
    function silent
        pueue add "$argv"
    end
else 
    function silent
        $argv &> /dev/null &
    end
end
