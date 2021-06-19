# Defined in /tmp/fish.oudI8g/tide-save.fish @ line 2
function tide-save --description 'Save all the tide variables into functions/tide-load.fish'
    echo "function tide-load -d 'Load saved tide configuration'" > "$FISH_CONFIG_DIR/functions/tide-load.fish"
    set --long | rg --no-config '^tide' | sed 's/^/set $argv /' >> "$FISH_CONFIG_DIR/functions/tide-load.fish" 
    echo "end" >> "$FISH_CONFIG_DIR/functions/tide-load.fish" 
end
