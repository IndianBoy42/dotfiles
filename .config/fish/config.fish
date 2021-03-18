set -gx PATH "$HOME/bin" $PATH;
set -gx PATH "$HOME/.cargo/bin" $PATH;
set -gx PATH "$HOME/.local/bin" $PATH;
set -gx PATH "$HOME/anaconda3/bin" $PATH;
zoxide init fish | source
# starship init fish | source
# set -gx PATH "$HOME/anaconda3/bin" $PATH  # commented out by conda initialize;
thefuck --alias | source

set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
alias rgrep 'rg --no-config'
abbr rgl 'rg -C0'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
status is-interactive && eval /home/amedhi/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

abbr reload_profile 'source ~/.config/fish/config.fish'
function codeprofile
	code -w ~/.config/fish/config.fish
	source ~/.config/fish/config.fish
end
function profile
	nvim ~/.config/fish/config.fish
	source ~/.config/fish/config.fish
end
function silent
	$argv &> /dev/null &
end
abbr k 'eval $history[1]'
abbr kk 'eval $history[2]'
abbr sudo!! 'eval sudo $history[1]'

# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f /home/amedhi/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin /home/amedhi/.ghcup/bin $PATH

abbr cg "cargo"
abbr cgcl "cargo clean"
abbr cgr "cargo r"
abbr cgrr "cargo r --release"
abbr cgc "cargo check"
abbr cgt "cargo test"
abbr cgb "cargo build"
abbr cgbr "cargo build --release"
abbr cgbe "cargo bench"
abbr cgwc "cargo watch -x check --clear"

abbr zib "zig build"
abbr zir "zig run"
abbr zit "zig test"
abbr zif "zig fmt"
abbr zitc "zig translate-c"
abbr zcc "zig cc"
abbr zc++ "zig c++"
abbr ziinit "zig init-exe"

abbr py "python"
abbr l "lsd -A"
abbr lr "lsd -AR --depth 2"
abbr ll "lsd -alh"
abbr lt "lsd --tree -A"
abbr apti "sudo apt install -y"
abbr apts "apt search"
abbr mkdp "mkdir -p"
function mkcd 
	mkdir -p $argv;
	cd $argv;
end
abbr justdoit "sudo !!"

abbr rcd 'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'


function rga-fzf-broken
	set RG_PREFIX "rga --files-with-matches"
	local file
	file="(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
end

set -gx CMAKE_CLANG "MAKE_C_COMPILER=clang CMAKE_CXX_COMPILER=clang++"
set -gx CMAKE_GCC "CMAKE_C_COMPILER=gcc CMAKE_CXX_COMPILER=g++"
set -gx CMAKE_ARM "CMAKE_C_COMPILER=arm-none-eabi-gcc CMAKE_CXX_COMPILER=arm-none-eabi-g++"
set -gx CMAKE_ZIG "CMAKE_C_COMPILER=zig\ cc CMAKE_CXX_COMPILER=zig\ c++"
set -gx CMAKE_GENERATOR "Ninja"
set -gx CMAKE_BUILD_TYPE "Release"
set -gx MAKEFLAGS "-j 18"
function vim_n_source
	nvim $argv
	source $argv
end
function code_n_source
	code -w $argv
	source $argv
end
abbr edex vim_n_source
abbr cedex code_n_source

function cpmark
	set -gx CP_TO (pwd)
	echo $CP_TO
end
function gomark 
	cd $CP_TO
end
function cpto 
	cp $argv $CP_TO
end

set -gx CMAKE_BUILD_TYPE Release
set -gx CMAKE_GENERATOR Ninja

set -gx EDITOR nvim

set -gx SPT_FORMAT '%f %s %p : %t - %a (%b) - %v% - playing on %d'
abbr sptnext "spt playback --next -f '$SPT_FORMAT'"
abbr sptn sptnext
abbr sptprev "spt playback --previous -f '$SPT_FORMAT'"
abbr sptpb "spt playback -f '$SPT_FORMAT'"
abbr sptplay "spt playback --toggle -f '$SPT_FORMAT'"
abbr sptp sptplay
abbr sptvol "spt playback -f '$SPT_FORMAT' --volume"
abbr sptlike "spt playback --like -f '$SPT_FORMAT'"
abbr sptf "spt search"
abbr sptfl "spt search --playlists"
abbr sptfa "spt search --artists"
abbr sptfal "spt search --albums"
abbr sptft "spt search --tracks"
abbr sptpl "spt play -f '$SPT_FORMAT' --playlist --name"
abbr sptpa "spt play -f '$SPT_FORMAT' --artist --name"
abbr sptpal "spt play -f '$SPT_FORMAT' --album --name"
abbr sptpt "spt play -f '$SPT_FORMAT' --track --name"

function gvm
  bass source ~/.gvm/scripts/gvm ';' gvm $argv
end

function echopath
	echo $PATH | sed 's/ /\n/g'
end

abbr open xdg-open

alias zf=__fzf_search_current_dir
bind \cz 'zi'
abbr z- 'z -'

status --is-interactive; and ix -u &> /dev/null &

abbr pu pueue
abbr pusts pueue status

function touchp
	mkdir -p (dirname $argv)
	touch $argv
end
