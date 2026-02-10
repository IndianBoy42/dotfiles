# apt abbreviations
if type -q nala
    abbr apt nala
    set apt_prefix nala
else
    set apt_prefix apt
end
abbr -a --command nala --command apt i install
abbr -a apti sudo $apt_prefix install
abbr -a --command nala --command apt y "install -y"
abbr -a --command nala --command apt s search
abbr -a --command nala --command apt r remove
abbr -a --command nala --command apt u update
abbr -a --command nala --command apt ur upgrade
abbr -a aptur sudo $apt_prefix upgrade
abbr -a --command nala --command apt ou "update && sudo $apt_prefix --only-upgrade install "
abbr -a --command nala --command apt ar autoremove
abbr -a --command nala --command apt li "list --installed"
abbr -a --command nala --command apt si "list --installed | fzf"

