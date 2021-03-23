#!/usr/bin/env fish

if not type -q brew
	set tmpfile (mktemp)
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > $tmpfile
	bash $tmpfile
end
brew install zig
brew install fzf
