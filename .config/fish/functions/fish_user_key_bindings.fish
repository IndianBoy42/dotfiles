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
    bind \ez 'bg 2>/dev/null; commandline -f repaint'
    bind -M insert \ez 'bg 2>/dev/null; commandline -f repaint'
    bind -M insert ctrl-tab zc
    bind -M insert ctrl-\; nvim
    bind -M default ctrl-\; nvim

    fzf_jj_fish_bindings
end
