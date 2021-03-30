declare-user-mode user-buffer
declare-user-mode select-words
declare-user-mode select-lines
declare-user-mode matching


map global view i <esc><a-i> -docstring "Select Inside"
map global view a <esc><a-a> -docstring "Select Around"

map global user i <a-i> -docstring 'Select Inside'
map global user a <a-a> -docstring 'Select Around'

map global user q ': q' -docstring 'Quit'

map global user b ': enter-user-mode<space>user-buffer<ret>' -docstring '+Buffer'
map global user-buffer b ': buffer ' -docstring 'Switch Buffer'
map global user-buffer d ': delete-buffer<ret>' -docstring 'Delete Buffer'
map global user-buffer n ': buffer-next<ret>' -docstring 'Next Buffer'
map global user-buffer p ': buffer-previous<ret>' -docstring 'Previous Buffer'
map global user-buffer w ': write<ret>' -docstring 'Write Buffer'
map global user-buffer W ': write ' -docstring 'Write Buffer to {file}'
map global user-buffer o ': edit ' -docstring 'Open File'
map global user-buffer D ': buffer *debug*<ret>' -docstring 'Debug Buffer'

map global user s '*N: enter-user-mode -lock matching<ret>' -docstring '+Matches'
map global matching s N -docstring 'Add next match'
map global matching n N -docstring 'Add next match'
map global matching n N -docstring 'Add next match'
map global matching N <a-N> -docstring 'Add prev match'
map global matching j n -docstring 'Go to next matching'
map global matching k n -docstring 'Go to prev matching'
map global matching y y
map global matching r r
map global matching R R
map global matching d d
map global matching c c
map global matching <a-d> <a-d>
map global matching <a-c> <a-c>

declare-user-mode enter
map global user <ret> ': enter-user-mode enter<ret>' -docstring '+Enter Insert'
map global enter H '<esc>I' -docstring '⇐ insert before line'
map global enter h '<esc>i' -docstring '← insert before'
map global enter j '<esc>o' -docstring '↓ insert below'
map global enter k '<esc>O' -docstring '↑ insert above'
map global enter l '<esc>a' -docstring '→ insert after'
map global enter L '<esc>A' -docstring '⇒ insert after line'

map global user w ': enter-user-mode -lock select-words<ret>' -docstring '+words'
map global select-words w W -docstring 'next word start'
map global select-words b B -docstring 'prev word start'
map global select-words e E -docstring 'next word end'
map global select-words W <a-W> -docstring 'Xt next WORD start'
map global select-words B <a-B> -docstring 'Xt prev WORD start'
map global select-words E <a-E> -docstring 'Xt next WORD end'
map global select-words s '<esc><a-i>w*n' -docstring 'Search matches'
map global select-words y y
map global select-words r r
map global select-words R R
map global select-words d d
map global select-words c c
map global select-words <a-d> <a-d>
map global select-words <a-c> <a-c>

map global user l ': enter-user-mode select-lines<ret>' -docstring '+Lines'
map global select-lines e <a-l> -docstring 'End of Line'
map global select-lines b <a-h> -docstring 'Beginning of Line'
map global select-lines H <a-L> -docstring 'Xt End of Line'
map global select-lines L <a-H> -docstring 'Xt Beginning of Line'
declare-user-mode selecting-lines
map global user v 'x: enter-user-mode -lock selecting-lines<ret>' -docstring '+Select Lines'
map global select-lines j 'J<a-x>: enter-user-mode -lock selecting-lines<ret>' -docstring 'Down'
map global select-lines k 'K<a-x>: enter-user-mode -lock selecting-lines<ret>' -docstring 'Up'
map global selecting-lines j 'J<a-x>' -docstring 'Up'
map global selecting-lines k 'K<a-x>' -docstring 'Down'
map global selecting-lines y y
map global selecting-lines r r
map global selecting-lines R R
map global selecting-lines d d
map global selecting-lines c c
map global selecting-lines <a-d> <a-d>
map global selecting-lines <a-c> <a-c>
map global selecting-lines s '<esc>*n' -docstring 'Search matches'
                                                                                                                                                                                                                                                               map global selecting-lines l <a-s> -docstring 'Split to Lines'
map global selecting-lines \; <a-\;> -docstring 'Cursor'

map global select-lines J ': vertical-selection-down<ret>' -docstring 'Down all line'
map global select-lines K ': vertical-selection-up<ret>' -docstring 'Up all line'

map global user / ': exec /<ret>\Q\E<left><left>' -docstring 'Search regex disabled'
map global user ? '/(?i)'                         -docstring 'Search case insensitive'

declare-user-mode format
map global user f ': enter-user-mode format<ret>' -docstring '+Format'
map global format j '<esc>`'                          -docstring '↓ lowercase'
map global format k '<esc>~'                          -docstring '↑ uppercase'
map global format s '<esc><a-`>'                      -docstring '↕ switchcase'
map global format f ': format<ret>'                   -docstring 'format'
map global format c ': comment-line<ret>'             -docstring 'comment-line'
map global format C ': comment-block<ret>'            -docstring 'comment-block'
map global format t ': set global indentwidth 0<ret>' -docstring 'indent tab'
map global format 2 ': set global indentwidth 2<ret>' -docstring 'indent space 2'
map global format 4 ': set global indentwidth 4<ret>' -docstring 'indent space 4'
