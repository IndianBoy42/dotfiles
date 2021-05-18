# Defined in /home/amedhi/.config/fish/config.fish @ line 85
function fdinstall
   fd -IH --type f '.' ~/install-system.sh/ | fzf 
end
