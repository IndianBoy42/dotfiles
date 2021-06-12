# Defined interactively
function lets
    if count $argv > /dev/null
        if test -e ~/.letsfiles/$argv[1].just
            just --justfile ~/.letsfiles/$argv[1].just --working-directory ~ $argv[2..-1]
            return 0
        end
    end
    just --justfile ~/.letsfiles/Justfile --working-directory ~ $argv
end
