#!/usr/bin/env fish

if not type -q brew
	set tmpfile (mktemp)
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > $tmpfile
	bash $tmpfile
	eval (~/../linuxbrew/.linuxbrew/bin/brew shellenv)
end
brew install cmake gcc ninja
brew install --cask gcc-arm-embedded
brew install zig --HEAD
brew install fzf
