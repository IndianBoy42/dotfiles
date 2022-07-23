function whch --description 'More detail which command'
    argparse --name="whch" h/help l/lsd-alh -- $argv
    or return
    if test -n "$_flag_l"
        lsd -alh (type -a $argv | sed "s/$argv is //")
    else
        type -ap $argv
    end
end
