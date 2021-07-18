function touchp
    for arg in $argv
        mkdir -p (dirname $arg)
        touch $arg
    end
end
