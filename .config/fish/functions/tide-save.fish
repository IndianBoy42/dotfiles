function tide-save -d "Save all the tide variables into functions/tide-load.fish"
    echo "function tide-load -d 'Load saved tide configuration'" > "$FISH_CONFIG_DIR/functions/tide-load.fish"
    set --long | rgrep '^tide' | sed 's/^/set $argv /' >> "$FISH_CONFIG_DIR/functions/tide-load.fish" 
    echo "end" >> "$FISH_CONFIG_DIR/functions/tide-load.fish" 
end

