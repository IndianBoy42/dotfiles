function zi
    commandline -rt (zoxide query --interactive (commandline -t))
    or commandline -f repaint
end
function zc
    commandline -rt (zoxide query (commandline -t))
    or commandline -f repaint
end

function fish_user_key_bindings
    bind -M insert \cg expand_glob
    bind \cz 'fg 2>/dev/null; commandline -f repaint'
    bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
    bind -M insert \ez zi
    bind -M insert \eZ zc
    bind -M default cd kn
    bind -M insert ctrl-\; nvim
    bind -M default ctrl-\; nvim
end
