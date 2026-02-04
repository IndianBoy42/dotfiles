# TODO: more abbrs for subcommands
##################################
# conf.d scripts run before this 
##################################

set -gx TERMINAL $TERM

if status is-login
    system76-power profile performance
end

##################################
# PATH setup
##################################

if type -q ~/anaconda3/bin/conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
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
fish_add_path ~/.local/share/coursier/bin
fish_add_path ~/.opencode/bin
fish_add_path ~/AppImages/
fish_add_path $FISH_CONFIG_DIR/conf.d/bin/
set -gx LUA_PATH "$HOME/.local/packages/luarocks/share/lua/5.4/?.lua;$HOME/.local/packages/luarocks/lib/lua/5.4/?.lua;;"
# fish_add_path ~/anaconda3/bin

# git-subrepo
if test -e ~/git-builds/git-subrepo/.fish.rc
    set GIT_SUBREPO_ROOT (dirname (realpath (status --current-filename)))
    fish_add_path $GIT_SUBREPO_ROOT/lib
end

set -gx FISH_ACTIVATE_NIX 1
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
        if test -e $FISH_ACTIVATE_NIX_PROFILE/etc/profile.d/nix.sh
            if bass source $FISH_ACTIVATE_NIX_PROFILE/etc/profile.d/nix.sh
                any-nix-shell fish --info-right | source

                # Guard repeated activations
                set -g FISH_NIX_ACTIVATED 1
            end
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

abbr open xdg-open
abbr del 'rm -vi'
abbr lc 'wc -l'

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

abbr ps procs
abbr pst procs --tree
abbr psmem 'ps auxf | sort -nr -k 4 | less'
abbr pscpu 'ps auxf | sort -nr -k 3 | less'
abbr psmem10 'ps auxf | sort -nr -k 4 | head -10'
abbr pscpu10 'ps auxf | sort -nr -k 3 | head -10'

# ripgrep stuff, config and aliases
abbr rg 'rg -S'
abbr rgc 'rg -SC3'
abbr rge 'rg -S -uuu'
abbr fde 'fd -uuu'

# pueue is really cool
abbr pu pueue
abbr pusts pueue status

# yadm helper abbreviations
abbr yad yadm
abbr yadd 'yadm add'
#abbr yaddi 'yadm addi'
abbr yads 'yadm status'
abbr yadf 'yadm fetch'
#abbr yadi yadm enter verco
abbr yaddconfigs yadm add --update ~/.config/
abbr yaddinstall yadm add ~/install-system.sh/
abbr yaddupdate yadm add --update ~

# alias yalo 'yadm enter git forgit log'
# alias yadf 'yadm enter git forgit diff'
# alias yadd 'yadm enter git forgit add'
# alias yarh 'yadm enter git forgit reset_head'
# alias yai 'yadm enter git forgit ignore'
# alias yacf 'yadm enter git forgit checkout_file'
# alias yacb 'yadm enter git forgit checkout_branch'
# alias yabd 'yadm enter git forgit branch_delete'
# alias yact 'yadm enter git forgit checkout_tag'
# alias yaco 'yadm enter git forgit checkout_commit'
# alias yarc 'yadm enter git forgit revert_commit'
# alias yaclean 'yadm enter git forgit clean'
# alias yass 'yadm enter git forgit stash_show'
# alias yasp 'yadm enter git forgit stash_push'
# alias yacp 'yadm enter git forgit cherry_pick'
# alias yarb 'yadm enter git forgit rebase'
# alias yabl 'yadm enter git forgit blame'
# alias yafu 'yadm enter git forgit fixup'

# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f ~/.ghcup/env
and fish_add_path ~/.cabal/bin ~/.ghcup/bin

# super short cargo abbreviations
abbr cg cargo
abbr -a --command cargo cl clean
abbr -a --command cargo r run
abbr -a --command cargo rr "run --release"
abbr -a --command cargo c check
abbr -a --command cargo t test
abbr -a --command cargo b build
abbr -a --command cargo br "build --release"
abbr -a --command cargo be bench
abbr -a --command cargo wc "watch -x check --clear"
abbr BT "RUST_BACKTRACE=1"
abbr MUSL CARGO_BUILD_TARGET=x86_64-unknown-linux-musl

abbr watchbuild "watchexec -cw . -i build --"

abbr xa "xargs -I _"
abbr xl "xargs -I _ lsd -aFl _"

# super short zig abbreviations
abbr -a --command zig b build
abbr -a --command zig r run
abbr -a --command zig t test
abbr -a --command zig f fmt
abbr -a --command zig tc translate-c
abbr -a --command zig new init-exe
abbr zcc "zig cc"
abbr zc++ "zig c++"

abbr py uv run python
abbr python uv run python
abbr pip uv pip
abbr uvs uv run --script

# lsd abbreviations
if type -q lsd
    abbr -g l "lsd -AF"
    abbr -g ls "lsd -AF"
    abbr -g la "lsd -aFl"
    abbr -g ll "lsd -aFl"
    abbr -g lsc "lsd -A --color always --icon always"
    abbr -g lr "lsd -AR --depth 2"
    abbr -g lt "lsd --tree -A"
    abbr -g ltd "lsd --tree -A --depth"
else
    # TODO: Backup pretty ls abbrs
end
# zoxide fzf stuff?
alias zf=__fzf_search_current_dir
abbr fz 'fzf --preview=\'v {}\''
#abbr zhome 'z ~ && z (__fzf_search_current_dir)'
abbr z- 'z -'
# type -q zoxide
# and abbr -g cd z
# type -q _kn
# and abbr -g cd kn
# and abbr -g / kn
# and abbr -g . kn
abbr -g / cd; and abbr -g . cd

if type -q pacstall
    abbr pac pacstall
    abbr -a --command pacstall i -- -I
    abbr -a --command pacstall r -- -R
    abbr -a --command pacstall s -- -S
    abbr -a --command pacstall a -- -A
    abbr -a --command pacstall u -- -U
    abbr -a --command pacstall ur -- -Up
end

# apt abbreviations
if type -q nala
    abbr apt nala
    set apt_prefix nala
else
    set apt_prefix apt
end
abbr -a --command nala --command apt i install
abbr -a apti sudo $apt_prefix install
abbr -a --command nala --command apt y "install -y"
abbr -a --command nala --command apt s search
abbr -a --command nala --command apt r remove
abbr -a --command nala --command apt u update
abbr -a --command nala --command apt ur upgrade
abbr -a aptur sudo $apt_prefix upgrade
abbr -a --command nala --command apt ou "update && sudo $apt_prefix --only-upgrade install "
abbr -a --command nala --command apt ar autoremove
abbr -a --command nala --command apt li "list --installed"
abbr -a --command nala --command apt si "list --installed | fzf"

# mkdir helpers
# make all directories and create the file
abbr mk "mkdir -p"

abbr j just
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
# if type -q mold
#     set -q LDFLAGS; or set -gx LDFLAGS "-fuse-ld=mold"
# else
#     set -q LDFLAGS; or set -gx LDFLAGS "-fuse-ld=lld"
# end
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

abbr paste wl-paste
abbr copy wl-copy

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
set -gx EDITOR nvim
function echo_editor --wraps $EDITOR
    echo $EDITOR
end
abbr ed --function echo_editor
function echo_gui_editor --wraps $EDITOR
    echo $GUI_EDITOR
end
set -gx GUI_EDITOR (which neovide)
abbr ed --function echo_editor
set -gx VISUAL $EDITOR
#set -gx PAGER nvim
# set -gx NVIM_APPNAME lazynvim
if type -q nvim
    # if type -q nvr
    #     if test -z "$nvr"
    #         if test -n "$NVIM_LISTEN_ADDRESS"
    #             and type -q nvr
    #             set -g nvr "nvr --remote"
    #             abbr -g nvim $nvr
    #             abbr -g vim $nvr
    #             abbr -g vi $nvr
    #         else
    #             set -gx NVIM_LISTEN_ADDRESS /tmp/nvimsocket.$fish_pid
    #             set -g nvr "nvr --remote-wait-silent"
    #             abbr -g nvim $nvr
    #             abbr -g vim $nvr
    #             abbr -g vi $nvr
    #         end
    #     end
    #     # Launch without any listening
    #     abbr -g neovim command nvim
    # else
    abbr -e nvim
    abbr -g vim nvim
    abbr -g nvi nvim
    abbr -g vi nvim
    abbr -g vr command nvr --remote
    abbr -g vrt command nvr --remote-tab
    abbr -g vrw command nvr --remote-wait
    abbr -g vrtw command nvr --remote-tab-wait
    # end
end

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

if type -q bass
    and type -q gvm
    gvm use latest &>/dev/null
end
if type -q nvm
    nvm use latest &>/dev/null
end

# Reindex (indexa) if is-interactive
# if type -q ix
#     status --is-interactive; and ix -u &>/dev/null &
# end
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

abbr g git
abbr -a --command git s status
abbr -a --command git c commit
abbr -a --command git cv "commit -v"
abbr -a --command git f "fetch --all"
abbr -a --command git a add
abbr -a --command git u up
abbr -a --command git d down
abbr -a --command git sw switch
abbr -a --command git addi "add --interactive"
abbr -a --command git new "checkout -b"
abbr -a --command git save "commit -av"
abbr -a --command git save-all "add -A && git commit"
abbr -a --command git wip "commit -am WIP"
abbr -a --command git undo "reset HEAD~1 --mixed"
abbr -a --command git amend "commit --amend"
abbr -a --command git sync "fetch && git pull --ff-only && git push -u origin HEAD"
# abbr -a --command git down "pull --rebase --prune $@ && git submodule update --init --recursive"
abbr -a --command git up "push -u origin HEAD"
abbr -a --command git ec "config --global -e"
abbr -a --command git unstage "restore --staged"
abbr -a --command git list-aliases "config -l | grep alias | cut -c 7-"
abbr -a --command git ra "remote add"
abbr -a --command git rao "remote add origin"
abbr -a --command git clean-merged "branch --merged | grep -v \"\\*\" | xargs -n 1 git branch -d"
abbr -a --command git sm submodule
abbr -a --command git root "rev-parse --show-toplevel"
abbr -a --command git pre-pull "diff @ @{upstream}"
abbr -a --command git any-changes "diff --no-ext-diff --quiet --exit-code"
abbr -a --command git untracked "ls-files . --exclude-standard --others"
abbr -a --command git tracked "ls-tree -r HEAD --name-only "
abbr -a --command git staged "diff --staged"
abbr -a --command git partial-clone "clone --filter=blob:none"
abbr -a --command git shallow-clone "clone --filter=tree:0"
abbr -a --command git unshallow "fetch --unshallow"
abbr -a --command git fork-point "merge-base --fork-point origin/master"
abbr -a --command git autosquash "rebase -i --autosquash"
abbr -a --command git diff1 "diff HEAD~1 HEAD"
abbr -a --command git dft difftool
abbr -a --command git dft1 "difftool HEAD~1 HEAD"
abbr -a --command git dp "diff @{1} HEAD"

abbr yta-aac "youtube-dl --extract-audio --audio-format aac "
abbr yta-best "youtube-dl --extract-audio --audio-format best "
abbr yta-flac "youtube-dl --extract-audio --audio-format flac "
abbr yta-m4a "youtube-dl --extract-audio --audio-format m4a "
abbr yta-mp3 "youtube-dl --extract-audio --audio-format mp3 "
abbr yta-opus "youtube-dl --extract-audio --audio-format opus "
abbr yta-vorbis "youtube-dl --extract-audio --audio-format vorbis "
abbr yta-wav "youtube-dl --extract-audio --audio-format wav "
abbr ytv-best "youtube-dl -f bestvideo+bestaudio "

abbr esperase "uvx esptool --port /dev/ttyACM0 erase-flash"
abbr espflash "uvx esptool --port /dev/ttyACM0 write-flash 0 "

if type -q direnv
    direnv hook fish | source
end

abbr tarz 'tar --zstd'

abbr sysc 'systemctl --user'
abbr ssysc 'sudo systemctl'

abbr ai opencode
abbr oc opencode
abbr ocask opencode --agent codebase
abbr ask opencode --agent codebase --prompt

if test "$TERM" = alacritty
    abbr itty alacritty &>/dev/null &
else if test "$TERM" = xterm-kitty
    abbr itty kitty &>/dev/null &
    abbr klayout kitty @ goto-layout
    abbr knew kitty @ launch
    abbr kls 'kitty @ ls | jless'
end

abbr letsid lets install --dry-run
abbr letsi lets install
abbr flathub flatpak install --or-update flathub
abbr remake 'make clean && make'

abbr ksh "kitten ssh"
abbr kc "kitten choose-files --mode=files"
abbr kd "cd (dirname (kitten choose-files))"

set -x FORGIT_FZF_DEFAULT_OPTS "
--ansi
--height='80%'
--bind='alt-k:preview-up,alt-p:preview-up'
--bind='alt-j:preview-down,alt-n:preview-down'
--bind='ctrl-r:toggle-all'
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--bind='alt-w:toggle-preview-wrap'
--preview-window='right:60%'
+1

"
set -x FORGIT_GI_REPO_LOCAL ""
set -x FORGIT_GI_REPO_REMOTE "https://github.com/dvcs/gitignore"
set -x FORGIT_GI_TEMPLATES ""

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

ulimit -Sn (ulimit -Hn)

##################################
# Run other configs
##################################

for file in $FISH_CONFIG_PATH.d/*.fish
    source $file
end

# source .env
envsource $HOME/.env

test -e /tmp/.tio

or mkdir /tmp/.tio

# moonbit
fish_add_path "$HOME/.moon/bin"
