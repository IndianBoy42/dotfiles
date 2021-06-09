if type -q ~/anaconda3/bin/conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
status is-interactive && eval /home/amedhi/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
end

set -gx PIPENV_VENV_IN_PROJECT 1
set -gx TERMINAL alacritty
set -gx VIRTUAL_ENV_DIR .venv 
set -gx PKG_CONFIG_PATH $PKG_CONFIG_PATH /usr/lib/x86_64-linux-gnu/pkgconfig/
set -gx PKG_CONFIG_PATH $PKG_CONFIG_PATH /usr/local/lib/pkgconfig/ 
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
if type -q _kn
	_kn init fish | source
end

# git-subrepo
if test -e ~/git-builds/git-subrepo/.fish.rc
	source ~/git-builds/git-subrepo/.fish.rc
end

set -gx CUDACXX /usr/lib/cuda/bin/nvcc

# Use starship (I prefer fish tide for now)
# starship init fish | source

# alias thefuck for quick correct in the shell
#if type -q thefuck
#	status is-interactive; and thefuck --alias fk | source
#end

##################################
# functions / abbrs
##################################

abbr del rm -vi

abbr pst procs --tree
abbr psmem 'ps auxf | sort -nr -k 4 | less'
abbr pscpu 'ps auxf | sort -nr -k 3 | less'
abbr psmem10 'ps auxf | sort -nr -k 4 | head -10'
abbr pscpu10 'ps auxf | sort -nr -k 3 | head -10'

alias whch='type -a'

# ripgrep stuff, config and aliases
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
alias rgrep 'rg --no-config'
abbr rgl 'rg -C0'
abbr fda 'fd -HI'

# profile editing helper functions
abbr reload_profile 'source ~/.config/fish/config.fish'

# pueue is really cool
abbr pu pueue
abbr pusts pueue status

# repeat the previous command, the problem is you cant do this twice
abbr k ' run_previous_command'
abbr kk ' run_prev2_command'
abbr K ' run_history_command' 
abbr sukk ' sudo run_prev2_command'

# yadm helper abbreviations
abbr yad yadm
#abbr yadd 'yadm add'
#abbr yaddi 'yadm addi'
abbr yads 'yadm status'
abbr yadf 'yadm fetch'
#abbr yadi yadm enter verco
abbr yaddconfigs yadm add --update ~/.config/
abbr yaddinstall yadm add ~/install-system.sh/
abbr yaddupdate yadm add --update ~

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
# set -gx CARGO_BUILD_TARGET x86_64-unknown-linux-musl

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
if type -q lsd
    abbr -g l "lsd -A"
    abbr -g ls "lsd -A"
    abbr -g lr "lsd -AR --depth 2"
    abbr -g ll "lsd -alh"
    abbr -g lt "lsd --tree -A"
    abbr -g ltd "lsd --tree -A --depth"
    abbr -g la "lsd -alh"
end
# zoxide fzf stuff?
alias zf=__fzf_search_current_dir
#abbr zhome 'z ~ && z (__fzf_search_current_dir)'
abbr z- 'z -'
if type -q kn
    abbr -g cd kn
end

# apt abbreviations
abbr apti "sudo apt install"
abbr apts "apt search"
abbr aptr "sudo apt remove"
abbr aptu "sudo apt update && sudo apt upgrade"
abbr aptar "sudo apt autoremove"
abbr aptsi "apt list --installed | fzf"

# mkdir helpers
abbr mkdp "mkdir -p"
# make all directories and create the file

# ranger and then cd, dont think this works
abbr rcd 'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# define some variables for CMAKE
abbr cmake-clang "cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
abbr cmake-gcc "cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++"
abbr cmake-zig "cmake -DCMAKE_C_COMPILER=zig\ cc -DCMAKE_CXX_COMPILER=zig\ c++"
abbr cmake-zap "cmake -DCMAKE_C_COMPILER=zapcc -DCMAKE_CXX_COMPILER=zapcc"
set -gx CMAKE_GENERATOR "Ninja"
set -gx CMAKE_BUILD_TYPE "Release"
set -gx CMAKE_EXE_LINKER_FLAGS "-fuse-ld=gold"
set -gx CMAKE_EXPORT_COMPILE_COMMANDS "ON"
set -gx MAKEFLAGS -j (nproc)
set -gx JULIA_NUM_THREADS (nproc)
set -gx ZST_NBTHREADS 0 
set -gx ZST_CLEVEL 1
function FASTFLAGS
    set -gx CFLAGS "-O3 -march=native -mtune=native"
    set -gx CXXFLAGS "-O3 -march=native -mtune=native"
    set -gx CPPFLAGS $CXXFLAGS
    set -gx FFLAGS "-O3 -march=native -mtune=native"
    set -gx FCFLAGS "-O3 -march=native -mtune=native"
    set -gx CMAKE_C_FLAGS_RELEASE $CFLAGS
    set -gx CMAKE_CXX_FLAGS_RELEASE $CPPFLAGS
end

abbr edex ed_n_source
abbr cedex code_n_source
abbr coda code -a

# for copying across long trees, you can mark a place to copy to (and then copy/go to it)
abbr cpmark 'set -gx CP_TO (pwd) && echo $CP_TO	'
abbr gomark 'cd $CP_TO'
function cpto 
	cp $argv $CP_TO
end
function mvto
	mv $argv $CP_TO
end

# I guess ill use nvim inside the terminal
set -gx EDITOR nvim #kak
set -gx VISUAL $EDITOR
#set -gx PAGER nvim
if type -q nvim
    abbr -g vim nvim
    abbr -g vi nvim
end

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

if type -q bass
	gvm use latest &> /dev/null
end
if type -q nvm
	nvm use lts &> /dev/null
end

# what even is xdg
abbr open xdg-open

# Reindex (indexa) if is-interactive
if test -x ix
	status --is-interactive; and ix -u &> /dev/null &
end
set -g fish_key_bindings fish_vi_key_bindings


# pueue is really cool
abbr pu pueue
abbr pusts pueue status

abbr ros2-foxy bass source /opt/ros/foxy/setup.bash
abbr ros-noetic bass source /opt/ros/noetic/setup.bash

# abbr g git
# # Alias all git aliases
# for al in (git config -l | grep '^alias\.' | cut -d'=' -f1 | cut -d'.' -f2)
#     abbr g$al "git $al"
# end
# abbr gdiff git diff
abbr addup 'git add -u'
abbr addall 'git add .'
abbr branch 'git branch'
abbr checkout 'git checkout'
abbr clone 'git clone'
abbr commit 'git commit -m'
abbr fetch 'git fetch'
abbr pull 'git pull origin'
abbr push 'git push origin'
abbr tag 'git tag'
abbr newtag 'git tag -a'
abbr gits 'git s'
abbr gitf 'git f'

abbr scr scriptisto
abbr scrt scriptisto template
abbr scrts scriptisto template ls
# abbr scrnew scriptisto new

abbr yta-aac "youtube-dl --extract-audio --audio-format aac "
abbr yta-best "youtube-dl --extract-audio --audio-format best "
abbr yta-flac "youtube-dl --extract-audio --audio-format flac "
abbr yta-m4a "youtube-dl --extract-audio --audio-format m4a "
abbr yta-mp3 "youtube-dl --extract-audio --audio-format mp3 "
abbr yta-opus "youtube-dl --extract-audio --audio-format opus "
abbr yta-vorbis "youtube-dl --extract-audio --audio-format vorbis "
abbr yta-wav "youtube-dl --extract-audio --audio-format wav "
abbr ytv-best "youtube-dl -f bestvideo+bestaudio "

if type -q direnv
	direnv hook fish | source
end

if type -q cod
	cod init %self fish | source
end

# setup on dir change hook
if status is-interactive 
    __reg_on_dir_change
end

#function postexec_source_profile --on-event fish_postexec
#	set argv (string split " " "$argv")
#	if test "$argv[1]" = "$EDITOR" -a (count $argv) -ge 2
#		set edited $argv[2]
#		#set edited (realpath $argv[2]) 
#		if test "$edited" = "(realpath $HOME/.config/fish/config.fish)"
#			echo -n 'Sourcing (realpath $HOME/.config/fish/config.fish)... '
#			source ~/.config/fish/config.fish
#			echo Done.
#		end
#		if test "$edited" = "/etc/hosts"
#			echo -n 'Sourcing (realpath $HOME/.config/fish/config.fish)... '
#			source ~/.config/fish/config.fish
#			echo Done.
#		end
#	end
#end

# nnn file manager settings
set -gx NNN_PLUG 'z:autojump;f:finder;p:preview-tui-ext;P:preview-tabbed;o:nuke'
set -gx NNN_OPENER "$HOME/.config/nnn/plugins/nuke"

alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

abbr tarz 'tar --zstd'

abbr syctl 'systemctl --user'
abbr ssyctl 'sudo systemctl'
