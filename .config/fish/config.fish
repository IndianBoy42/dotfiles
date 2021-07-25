##################################
# conf.d scripts run before this 
##################################

set -gx TERMINAL $TERM

##################################
# PATH setup
##################################

if type -q ~/anaconda3/bin/conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    status is-interactive && eval /home/amedhi/anaconda3/bin/conda "shell.fish" hook $argv | source
    # <<< conda initialize <<<
end

# linuxbrew add to env
# if type -q ~/../linuxbrew/.linuxbrew/bin/brew
# 	eval (~/../linuxbrew/.linuxbrew/bin/brew shellenv)
#   linuxbrew low priority
#   fish_add_path --append --move --path "~/../linuxbrew/.linuxbrew/bin"
# end

add_to_path /usr/lib/x86_64-linux-gnu/pkgconfig/ PKG_CONFIG_PATH
add_to_path /usr/local/lib/pkgconfig PKG_CONFIG_PATH
add_to_path /usr/lib/pkgconfig PKG_CONFIG_PATH
add_to_path "$HOME/.local/lib" LD_LIBRARY_PATH
add_to_path "$HOME/.local/libexec" LD_LIBRARY_PATH
fish_add_path ~/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
set -gx LUA_PATH "$HOME/.local/packages/luarocks/share/lua/5.4/?.lua;$HOME/.local/packages/luarocks/lib/lua/5.4/?.lua;;"
# fish_add_path ~/anaconda3/bin

# git-subrepo
if test -e ~/git-builds/git-subrepo/.fish.rc
    set GIT_SUBREPO_ROOT (dirname (realpath (status --current-filename)))
    fish_add_path $GIT_SUBREPO_ROOT/lib
end

if not set -q IN_NIX_SHELL
    and not set -q FISH_NIX_ACTIVATED
    ## Inside a Nix Environment

    # Default nix profile
    if test -n "$FISH_ACTIVATE_NIX"
        test -n "$FISH_ACTIVATE_NIX_PROFILE"
        or set -g FISH_ACTIVATE_NIX_PROFILE "~/.nix-profile"
    end

    # Activate the profile
    if test -n "$FISH_ACTIVATE_NIX_PROFILE"
        # TODO: https://github.com/lilyball/nix-env.fish
        if bass source $FISH_ACTIVATE_NIX_PROFILE/etc/profile.d/nix.sh
            any-nix-shell fish --info-right | source

            # Guard repeated activations
            set -g FISH_NIX_ACTIVATED 1
        end
    end

else
    ## Inside a Nix Shell

    # Move nix paths to the top of the PATH variable
    fish_add_path --move --global (echo $PATH | tr ' ' '\n' | grep 'nix/')
end

##################################
# functions / abbrs / settings
##################################

# profile editing helper functions
set -gx FISH_CONFIG_PATH (status filename)
set -gx FISH_CONFIG_DIR (status dirname)
abbr reload_profile "source $FISH_CONFIG_PATH"

set -gx PIPENV_VENV_IN_PROJECT 1
set -gx CUDACXX /usr/lib/cuda/bin/nvcc
set -gx VIRTUAL_ENV_DIR .venv

abbr del 'rm -vi'
abbr lc 'wc -l'

abbr pst procs --tree
abbr psmem 'ps auxf | sort -nr -k 4 | less'
abbr pscpu 'ps auxf | sort -nr -k 3 | less'
abbr psmem10 'ps auxf | sort -nr -k 4 | head -10'
abbr pscpu10 'ps auxf | sort -nr -k 3 | head -10'

# ripgrep stuff, config and aliases
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
abbr rgrep 'rg --no-config'
abbr rgl 'rg -C0'
abbr rga 'rg -uu'
abbr fda 'fd -uu'

# pueue is really cool
abbr pu pueue
abbr pusts pueue status

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
test -f /home/amedhi/.ghcup/env
and fish_add_path ~/.cabal/bin ~/.ghcup/bin

# super short cargo abbreviations
abbr cg cargo
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

abbr py python

# lsd abbreviations
if type -q lsd
    abbr -g l "lsd -A"
    abbr -g lsc "lsd -A --color always --icon always"
    abbr -g ls "lsd -A"
    abbr -g lr "lsd -AR --depth 2"
    abbr -g ll "lsd -al"
    abbr -g lt "lsd --tree -A"
    abbr -g ltd "lsd --tree -A --depth"
    abbr -g la "lsd -al"
else
    # TODO: Backup pretty ls abbrs
end
# zoxide fzf stuff?
alias zf=__fzf_search_current_dir
abbr fzfp 'fzf --preview=\'v {}\''
#abbr zhome 'z ~ && z (__fzf_search_current_dir)'
abbr z- 'z -'
type -q zoxide
and abbr -g cd z
type -q _kn
and abbr -g cd kn

# apt abbreviations
abbr apti "sudo apt install"
abbr apty "sudo apt install -y"
abbr apts "apt search"
abbr aptr "sudo apt remove"
abbr aptu "sudo apt update"
abbr aptug "sudo apt upgrade"
abbr aptou "sudo apt update && sudo apt --only-upgrade install "
abbr aptar "sudo apt autoremove"
abbr aptli "apt list --installed"
abbr aptsi "apt list --installed | fzf"

# mkdir helpers
# make all directories and create the file
abbr mkd "mkdir -p"

abbr justc "just --choose"
abbr justl "just --list"

# ranger and then cd, dont think this works
abbr rcd 'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# define some variables for CMAKE
abbr cmake-clang "cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -S . -B build"
abbr cmake-clang-12 "cmake -DCMAKE_C_COMPILER=clang-12 -DCMAKE_CXX_COMPILER=clang++-12 -S . -B build"
abbr cmake-gcc "cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -S . -B build"
abbr cmake-gcc-11 "cmake -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 -S . -B build"
abbr cmake-zig "cmake -DCMAKE_C_COMPILER=zig\ cc -DCMAKE_CXX_COMPILER=zig\ c++ -S . -B build"
abbr cmake-zap "cmake -DCMAKE_C_COMPILER=zapcc -DCMAKE_CXX_COMPILER=zapcc -S . -B build"
set -q CMAKE_GENERATOR; or set -gx CMAKE_GENERATOR Ninja
set -q CMAKE_BUILD_TYPE; or set -gx CMAKE_BUILD_TYPE Release
set -q CMAKE_EXPORT_COMPILE_COMMANDS; or set -gx CMAKE_EXPORT_COMPILE_COMMANDS ON
set -q LDFLAGS; or set -gx LDFLAGS "-fuse-ld=lld"
set -q MAKEFLAGS; or set -gx MAKEFLAGS -j (nproc)
set -q JULIA_NUM_THREADS; or set -gx JULIA_NUM_THREADS (nproc)
set -q ZST_NBTHREADS; or set -gx ZST_NBTHREADS 0
set -q ZST_CLEVEL; or set -gx ZST_CLEVEL 1

# TODO: cmake super short abbr
abbr ninja-targets "ninja -t targets"
abbr cmconf "cmake -S . -B build"
abbr cmbuild "cmake --build build"

abbr mimalloc "LD_PRELOAD=~/.local/lib/libmimalloc.so"
abbr jemalloc "LD_PRELOAD=(jemalloc-config --libdir)/libjemalloc.so.(jemalloc-config --revision)"

abbr edex ed_n_source
abbr cedex code_n_source
abbr coda code -a

abbr echov 'set --show'

# # for copying across long trees, you can mark a place to copy to (and then copy/go to it)
# abbr cpmark 'set -gx CP_TO (pwd) && echo $CP_TO	'
# abbr gomark 'cd $CP_TO'
# function cpto --wraps "cp"
# 	cp $argv $CP_TO
# end
# function mvto --wraps "mv"
# 	mv $argv $CP_TO
# end

# set -gx EDITOR nvim #kak
set -gx EDITOR ~/.local/bin/nvim-wrapper
set -gx VISUAL $EDITOR
#set -gx PAGER nvim
if test -n "$NVIM_LISTEN_ADDRESS"
    and type -q nvr
    alias nvim "nvr --remote-tab-wait"
    abbr -g vim nvr
    abbr -g vi nvr
    abbr -g nvim nvr
else if type -q nvim
    if type -q nvr
        # If a nvim server for this dir/repo has already been launched then  
        function nvim --wraps=vim --description Wrapper\ around\ nvim-remote\ to\ use\ servername\ according\ to\ the\ dir/repo\ you\'re\ in
            set addr "/tmp/nvimsockets"(realpath .)"/socketfile"
            test -n "$CURR_GIT_ROOT"; and set addr "/tmp/nvimsockets$CURR_GIT_ROOT/socketfile"
            # test -n "$argv[1]"; and set addr "$argv[1]" # TODO argparse servername/listen for the address
            # echo $addr
            mkdir -p (dirname $addr)

            command nvr -s --nostart --servername "$addr" $argv
            or command nvim --listen "$addr" $argv
        end
    end
    abbr -g vim nvim
    abbr -g vi nvim
    # Launch without any listening
    abbr -g vimn command nvim
    abbr -g nvimn command nvim
    abbr -g vin command nvim
end

# so many spotify-tui abbreviations
set -gx SPT_FORMAT '%f %s %p : %t - %a (%b) - %v% - playing on %d'
abbr sptnext " spt playback --next -f '$SPT_FORMAT'"
abbr sptn " spt playback --next -f '$SPT_FORMAT'"
abbr sptprev " spt playback --previous -f '$SPT_FORMAT'"
abbr sptpb " spt playback -f '$SPT_FORMAT'"
abbr sptplay " spt playback --toggle -f '$SPT_FORMAT'"
abbr sptp " spt playback --toggle -f '$SPT_FORMAT'"
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
    and type -q gvm
    gvm use latest &>/dev/null
end
if type -q nvm
    nvm use lts &>/dev/null
end

# Reindex (indexa) if is-interactive
if test -x ix
    status --is-interactive; and ix -u &>/dev/null &
end
set -g fish_key_bindings fish_vi_key_bindings

# pueue is really cool
abbr pu pueue
abbr pusts pueue status

if test -f /opt/ros/foxy/setup.bash
    abbr ros2-foxy bass source /opt/ros/foxy/setup.bash
end
if test -f /opt/ros/noetic/setup.bash
    abbr ros-noetic bass source /opt/ros/noetic/setup.bash
end

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

# nnn file manager settings
set -gx NNN_PLUG 'z:autojump;f:finder;p:preview-tui-ext;P:preview-tabbed;o:nuke'
set -gx NNN_OPENER "$HOME/.config/nnn/plugins/nuke"

alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

abbr tarz 'tar --zstd'

abbr syctl 'systemctl --user'
abbr ssyctl 'sudo systemctl'

##################################
# Run other configs
##################################

for file in $FISH_CONFIG_PATH.d/*.fish
    source $file
end
