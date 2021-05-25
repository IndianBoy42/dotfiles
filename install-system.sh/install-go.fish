#!/usr/bin/env fish

if not type -q gvm
	set tmpfile (mktemp)
	curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer > $tmpfile
	bash $tmpfile
    function gvm
      bass source ~/.gvm/scripts/gvm ';' gvm $argv
    end
    funcsave gvm
end
gvm install go1.16 -B && gvm use go1.16 --default
