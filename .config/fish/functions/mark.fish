function mark --description 'Drop a mark and then copy/move/etc to'
    if test -n "$argv"
        if test -d "$argv[1]" # Mark a directory
            set -gx __DIR_MARK "$argv[1]"
            and echo $__DIR_MARK
        else if test "$argv[1]" = tar # Handle tar specially
            $argv -C $__DIR_MARK
            # TODO: more special cases 
        else if test "$argv[1]" = unzip # Handle unzip specially
            $argv -d $__DIR_MARK
            # TODO: more special cases 
        else if test -x "$argv[1]"
            $argv $__DIR_MARK
        else
            set -gx __DIR_MARK "$argv[1]"
            and echo $__DIR_MARK
        end
    else # Mark the working directory
        set -gx __DIR_MARK (pwd)
        and echo $__DIR_MARK
    end
end
