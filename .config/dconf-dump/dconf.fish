#!/usr/bin/env fish

function dump-dconf --wraps=dconf --description 'dump all settings in dconf'
    dconf dump "$argv[1]" > ~/.config/dconf-dump/all.dconf
end
function load-dconf --wraps=dconf --description 'load all settings to dconf'
    dconf load "$argv[1]" < ~/.config/dconf-dump/all.dconf
end

switch "$argv[1]"
    case "dump":
        dump-dconf "$argv[2]"
    case "load":
        load-dconf "$argv[2]"
    case "dump-all":
        dump-dconf "/"
    case "load-all":
        load-dconf "/"
    case "dump-extensions":
        dump-dconf "/org/gnome/shell/extension"
    case "load-extensions":
        load-dconf "/org/gnome/shell/extension"
end
