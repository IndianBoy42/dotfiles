# so many spotify-tui abbreviations
set -gx SPT_FORMAT '%f %s %p : %t - %a (%b) - %v% - playing on %d'
abbr --command spt next "playback --next -f '$SPT_FORMAT'"
abbr --command spt n "playback --next -f '$SPT_FORMAT'"
abbr --command spt prev "playback --previous -f '$SPT_FORMAT'"
abbr --command spt pb "playback -f '$SPT_FORMAT'"
abbr --command spt play "playback --toggle -f '$SPT_FORMAT'"
abbr --command spt p "playback --toggle -f '$SPT_FORMAT'"
abbr --command spt vol "playback -f '$SPT_FORMAT' --volume"
abbr --command spt like "playback --like -f '$SPT_FORMAT'"
abbr --command spt f search
abbr --command spt fl "search --playlists"
abbr --command spt fa "search --artists"
abbr --command spt fal "search --albums"
abbr --command spt ft "search --tracks"
abbr --command spt pl "play -f '$SPT_FORMAT' --playlist --name"
abbr --command spt pa "play -f '$SPT_FORMAT' --artist --name"
abbr --command spt pal "play -f '$SPT_FORMAT' --album --name"
abbr --command spt pt "play -f '$SPT_FORMAT' --track --name"

