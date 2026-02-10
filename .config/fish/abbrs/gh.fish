abbr -command gh -- rl "release list -R"
abbr --command gh -- rv "release view -R"
abbr --set-cursor --command gh -- rd "release download -D /tmp/gh-release/ -R % -p '*'"
abbr --set-cursor --command gh -- dl "release download -D /tmp/gh-release/ -R % -p '*'"
abbr --command gh -- ,se --skip-existing
abbr --command gh -- ,cl --clobber
abbr --set-cursor --command gh -- paste gist create -d "%"

alias gh-gist="gh gist"
abbr gist gh-gist
abbr --command gh-gist -- c create
abbr --command gh-gist -- d clone
abbr --command gh-gist -- cl clone
abbr --command gh-gist -- e edit
abbr --command gh-gist -- v view
abbr --command gh-gist -- mv rename
abbr --command gh-gist -- rn rename
abbr --command gh-gist -- rm delete
abbr --command gh-gist -- l list
abbr --command gh-gist -- ls list
