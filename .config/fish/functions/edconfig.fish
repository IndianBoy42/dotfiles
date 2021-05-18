# Defined in /home/amedhi/.config/fish/config.fish @ line 91
function edconfig
   $EDITOR (   fd -IH --type f '.' ~/.config/ | fzf )
end
