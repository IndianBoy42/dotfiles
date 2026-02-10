# 'x0': The gold standard. Expects null-terminated input (like from 'find -print0').
# This handles filenames with spaces, newlines, and quotes correctly.
abbr --position anywhere --add -- ,0 --print0
abbr --add x0 "xargs -t -0"
# 'xi': Replacement mode. Allows you to put the argument anywhere in the command
# using '{}' as the placeholder.
abbr --add xi "xargs -t -I {}"
# 'x0i': A combination of the above. Null-terminated input + replacement strings.
abbr --add x0i "xargs -t -0 -I {}"
# 'xp': Run in parallel. Uses the maximum number of threads available on your CPU.
# '-P 0' means "max possible".
abbr --add xp "xargs -t -P 0"
# 'x0p': Parallel processing with null-terminated input safety.
abbr --add x0p "xargs -t -0 -P 0"
# 'xn': Run N arguments per command line. Useful if the target command
# has a limit on how many files it can handle at once.
abbr --add xn "xargs -n 1"

abbr --set-cursor --position anywhere --add shc "'bash -c \"%\"'"

abbr --set-cursor --add -- xfd "fd -0 % | xargs -0 -I {}"

abbr xa "xargs -I _"
abbr xl "xargs -I _ lsd -aFl _"
