# Defined interactively
function clifm_cd --wraps=clifm --description 'use clifm and when you close it: cd the last directory'
    clifm "--cd-on-quit" $argv

    if set -q XDG_CONFIG_HOME
        set cfgdir "$XDG_CONFIG_HOME"
    else
        set cfgdir "$HOME/.config"
    end
    set dir (grep "^\*" "$cfgdir/clifm/.last" 2>/dev/null | cut -d':' -f2)

    if test -d "$dir"
        cd -- "$dir" || return 1
    else
        printf "No directory specified\n" >&2
    end
end
