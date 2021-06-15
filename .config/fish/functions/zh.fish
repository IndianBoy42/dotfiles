# Defined in /tmp/fish.ED0HfY/zh.fish @ line 2
function zh
    set -l CHOICE (dirh | fzf --tac | sd '\s*[0-9]+\)\s*(.*)' '$1')
    if test -n "$CHOICE"
        cd $CHOICE
    end
end
