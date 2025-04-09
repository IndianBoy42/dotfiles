function venva
    #echo $argv[1]
    set venv ".venv"
    test -n "$argv[1]"; and set venv $argv[1]
    source $venv/bin/activate.fish
end
