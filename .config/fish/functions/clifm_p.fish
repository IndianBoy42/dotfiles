# Defined interactively
function clifm_p --wraps=clifm --description 'Use clifm as a file picker (selected files will be pass to CMD)'
    clifm $argv
    
    if set -q XDG_CONFIG_HOME
        set cfgdir "$XDG_CONFIG_HOME"
    else
        set cfgdir "$HOME/.config"
    end
    set file (find "$cfgdir/clifm" -name 'selbox*')
    if test -z "$file"
        set file (find "/tmp/clifm" -name 'selbox*')
    end

    if test -f "$file" 
        cat "$file"
        rm -- "$file"
    else
        printf "No selected files\n" >&2
        return 1
    end
end
