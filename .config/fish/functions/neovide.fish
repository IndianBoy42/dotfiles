# Defined interactively
function neovide
    command neovide $argv &>/dev/null &
    disown
end
