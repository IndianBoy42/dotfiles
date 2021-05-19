# Defined in /tmp/fish.RxQpqY/expand_glob.fish @ line 2
function expand_glob
    set -l tokens (eval string escape -- (commandline -ct))
    if set -q tokens[1]
        commandline -tr ""
        commandline -i -- "$tokens"
    end
end
