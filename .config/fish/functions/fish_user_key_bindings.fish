function fish_user_key_bindings
    bind -M insert \cg expand_glob
    bind \cz 'fg 2>/dev/null; commandline -f repaint'
    bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
    bind -M insert \ez zi
    bind -M default cd kn
end
