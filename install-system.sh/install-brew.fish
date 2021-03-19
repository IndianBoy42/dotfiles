#!/usr/bin/env fish

if not type -q brew
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
end
brew install zig
