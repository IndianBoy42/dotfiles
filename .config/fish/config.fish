set -gx PKG_CONFIG_PATH $PKG_CONFIG_PATH /usr/lib/x86_64-linux-gnu/pkgconfig/
set -gx PKG_CONFIG_PATH $PKG_CONFIG_PATH /usr/local/lib/pkgconfig/
# Add stuff to path
set -gx PATH "$HOME/bin" $PATH;
set -gx PATH "$HOME/.cargo/bin" $PATH;
set -gx PATH "$HOME/.local/bin" $PATH;
# set -gx PATH "$HOME/anaconda3/bin" $PATH;

# linuxbrew add to env
if type -q ~/../linuxbrew/.linuxbrew/bin/brew
	eval (~/../linuxbrew/.linuxbrew/bin/brew shellenv)
end

# Initialize zoxide (terminal cd jumper)
if type -q zoxide
	zoxide init fish | source
end

set -gx CUDACXX /usr/lib/cuda/bin/nvcc

# Use starship (I prefer fish tide for now)
# starship init fish | source

# alias thefuck for quick correct in the shell
#thefuck --alias | source
if type -q thefuck
	status is-interactive; and thefuck --alias fk | source
end

if type -q ~/anaconda3/bin/conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
status is-interactive && eval /home/amedhi/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
end

# functions / abbrs

alias whch='type -a'

# ripgrep stuff, config and aliases
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
alias rgrep 'rg --no-config'
abbr rgl 'rg -C0'
abbr fda 'fd -HI'

# profile editing helper functions
abbr reload_profile 'source ~/.config/fish/config.fish'
function codeprofile
	code -w ~/.config/fish/config.fish
	yadm add ~/.config/fish/config.fish
	source ~/.config/fish/config.fish
end
function profile
	$EDITOR ~/.config/fish/config.fish
	yadm add ~/.config/fish/config.fish
	source ~/.config/fish/config.fish
end
function install-script
	set file ~/install-system.sh/install-$argv.fish
	set tmpfile /(mktemp)
	cp $file $tmpfile
	$EDITOR $file
	yadm add $file
	delta $tmpfile $file
end

# run the command silently (should use pueue for this tbh)
function silent
	$argv &> /dev/null &
end
# pueue is really cool
abbr pu pueue
abbr pusts pueue status

# repeat the previous command, the problem is you cant do this twice
abbr k 'eval $history[1]'
abbr kk 'eval $history[2]'
abbr justdoit "sudo !!"
abbr sudo!! 'eval sudo $history[1]'

# yadm helper abbreviations
abbr yad yadm
abbr yadd 'yadm add'
abbr yaddi 'yadm addi'
abbr yads 'yadm status'
abbr yadi yadm enter verco

# cat(bat) or ls(lsd) all-in-one
function v
	if test -f $argv
		bat $argv
	else
		lsd -A $argv
	end
end

# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f /home/amedhi/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin /home/amedhi/.ghcup/bin $PATH

# super short cargo abbreviations
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
set -gx CARGO_BUILD_TARGET x86_64-unknown-linux-musl

abbr watchbuild "watchexec -cw . -i build --"

# super short zig abbreviations
abbr zib "zig build"
abbr zir "zig run"
abbr zit "zig test"
abbr zif "zig fmt"
abbr zitc "zig translate-c"
abbr zcc "zig cc"
abbr zc++ "zig c++"
abbr ziinit "zig init-exe"

# TODO: cmake super short abbr
abbr ninja-targets "ninja -t targets"

abbr py "python"

# lsd abbreviations
abbr l "lsd -A"
abbr lr "lsd -AR --depth 2"
abbr ll "lsd -alh"
abbr lt "lsd --tree -A"
abbr ltd "lsd --tree -A --depth"
# zoxide fzf stuff?
alias zf=__fzf_search_current_dir
bind \cz 'zi'
abbr z- 'z -'
abbr cd z
function zh
	cd (dirh | fzf --tac | sd '\s*[0-9]+\)\s*(.*)' '$1')
end
function zl
	z $argv
	lsd -A
end
function zil
	zi
	lsd -A
end

# apt abbreviations
abbr apti "sudo apt install -y"
abbr apts "apt search"
abbr aptr "sudo apt remove"
abbr aptu "sudo apt update && sudo apt upgrade"
abbr aptar "sudo apt autoremove"
abbr aptsi "apt list --installed | fzf"

# mkdir helpers
abbr mkdp "mkdir -p"
function mkcd 
	mkdir -p $argv;
	cd $argv;
end
# make all directories and create the file
function touchp
	mkdir -p (dirname $argv)
	touch $argv
end

# ranger and then cd, dont think this works
abbr rcd 'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# broken something about rg and fzf
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

# define some variables for CMAKE
abbr cmake-clang "cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
abbr cmake-gcc "cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++"
abbr cmake-zig "cmake -DCMAKE_C_COMPILER=zig\ cc -DCMAKE_CXX_COMPILER=zig\ c++"
abbr cmake-zap "cmake -DCMAKE_C_COMPILER=zapcc -DCMAKE_CXX_COMPILER=zapcc"
set -gx CMAKE_GENERATOR "Ninja"
set -gx CMAKE_BUILD_TYPE "Release"
set -gx CMAKE_EXE_LINKER_FLAGS "-fuse-ld=gold"
set -gx MAKEFLAGS -j (nproc)
set -gx CFLAGS "-O3 -march=native -mtune=native"
set -gx CXXFLAGS "-O3 -march=native -mtune=native"
set -gx FFLAGS "-O3 -march=native -mtune=native"
set -gx FCFLAGS "-O3 -march=native -mtune=native"

# edit and then run
function ed_n_source
	$EDITOR $argv
	source $argv
end
function code_n_source
	code -w $argv
	source $argv
end
abbr edex vim_n_source
abbr cedex code_n_source
abbr coda code -a

# for copying across long trees, you can mark a place to copy to (and then copy/go to it)
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
function mvto
	mv $argv $CP_TO
end

# I guess ill use nvim inside the terminal
set -gx EDITOR kak #nvim
set -gx VISUAL $EDITOR
# set -gx PAGER $EDITOR
abbr vim nvim
abbr vi nvim

# so many spotify-tui abbreviations
set -gx SPT_FORMAT '%f %s %p : %t - %a (%b) - %v% - playing on %d'
abbr sptnext " spt playback --next -f '$SPT_FORMAT'"
abbr sptn  " spt playback --next -f '$SPT_FORMAT'"
abbr sptprev " spt playback --previous -f '$SPT_FORMAT'"
abbr sptpb " spt playback -f '$SPT_FORMAT'"
abbr sptplay " spt playback --toggle -f '$SPT_FORMAT'"
abbr sptp  " spt playback --toggle -f '$SPT_FORMAT'"
abbr sptvol " spt playback -f '$SPT_FORMAT' --volume"
abbr sptlike " spt playback --like -f '$SPT_FORMAT'"
abbr sptf " spt search"
abbr sptfl " spt search --playlists"
abbr sptfa " spt search --artists"
abbr sptfal " spt search --albums"
abbr sptft " spt search --tracks"
abbr sptpl " spt play -f '$SPT_FORMAT' --playlist --name"
abbr sptpa " spt play -f '$SPT_FORMAT' --artist --name"
abbr sptpal " spt play -f '$SPT_FORMAT' --album --name"
abbr sptpt " spt play -f '$SPT_FORMAT' --track --name"

# gvm is weird and broken in fish lol
function gvm
  bass source ~/.gvm/scripts/gvm ';' gvm $argv
end

# echo the PATH and make each entry in a different line
function echopath
	echo $PATH | sed 's/ /\n/g'
end

# what even is xdg
abbr open xdg-open

# Reindex (indexa) if is-interactive
if test -x ix
	status --is-interactive; and ix -u &> /dev/null &
end
status --is-interactive; and fish_vi_key_bindings


# pueue is really cool
abbr pu pueue
abbr pusts pueue status

abbr ros2-foxy bass source /opt/ros/foxy/setup.bash
abbr ros-noetic bass source /opt/ros/noetic/setup.bash

abbr g git
# Alias all git aliases
for al in (git config -l | grep '^alias\.' | cut -d'=' -f1 | cut -d'.' -f2)
    abbr g$al "git $al"
end
abbr gdiff git diff

abbr scr scriptisto
abbr scrt scriptisto template
abbr scrts scriptisto template ls
# abbr scrnew scriptisto new
function scrnew
	scriptisto new $argv[1] > $argv[2]
	chmod +x $argv[2]
	lsd -Al $argv[2]
end
function watch-script
	watchexec -c -w $argv[1] "$argv[1]"
end

