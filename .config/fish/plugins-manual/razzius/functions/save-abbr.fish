function save-abbr --argument abbreviation
    set expansion "$argv[2..-1]"
    abbr $abbreviation $expansion
    echo "abbr $abbreviation \"$expansion\"" >>$FISH_CONFIG_DIR/abbrs/interactively_defined.fish
end
