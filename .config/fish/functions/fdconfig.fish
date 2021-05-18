# Defined in /home/amedhi/.config/fish/config.fish @ line 88
function fdconfig
   fd -IH --type f '.' ~/.config/ | fzf 
end
