function edconfig
   $EDITOR (   fd -IH --type f '.' ~/.config/ | fzf )
end
