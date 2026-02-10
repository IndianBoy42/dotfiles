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

if type -q carapace then
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    carapace _carapace | source
end

##################################
# functions / abbrs / settings
##################################

# profile editing helper functions
set -gx FISH_CONFIG_PATH (status filename)
set -gx FISH_CONFIG_DIR (status dirname)
abbr reload_profile "source $FISH_CONFIG_PATH"

set -gx CUDACXX /usr/lib/cuda/bin/nvcc

abbr open xdg-open
abbr del 'rm -vi'
abbr lc 'wc -l'

abbr export set -gx

abbr --command xdg-open gha 'https://github.com/$GITHUB_USERNAME/(basename $PWD)/commit/(git commit-id)/checks'
abbr --command xdg-open localhostport --regex ':\d+' 'localhost:'

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

abbr my-ip curl api.ipify.org

# pueue is really cool
abbr pu pueue
abbr pusts pueue status

# yadm helper abbreviations
# TODO: https://git.sr.ht/~ficd/autoyadm
abbr yad yadm
abbr yadd 'yadm add'
#abbr yaddi 'yadm addi'
abbr yads 'yadm status'
abbr yadf 'yadm fetch'

abbr wch "watchexec -cw . -i build --"

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
abbr --command fzf -a -- ,bat "--preview='bat {}'"
#abbr zhome 'z ~ && z (__fzf_search_current_dir)'
abbr z- 'z -'
# type -q zoxide
# and abbr -g cd z
# type -q _kn
# and abbr -g cd kn
# and abbr -g / kn
# and abbr -g . kn
abbr -g / cd; and abbr -g . cd

abbr -a PATH "set --show path"

# mkdir helpers
# make all directories and create the file
abbr mk "mkdir -p"

abbr j just
abbr justc "just --choose"
abbr justl "just --list"

# ranger and then cd, dont think this works
abbr rcd 'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

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

abbr paste 'wl-paste |'
abbr psel "wl-paste --primary |"
abbr clip wl-copy
abbr --position anywhere ,clp '(wl-paste | psub)'
abbr --position anywhere ,sel '(wl-paste --primary | psub)'
abbr --set-cursor --position anywhere ',p' '(% | psub)'

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

set ESP_TOOL "uvx esptool"
abbr esp $ESP_TOOL
abbr --command $ESP_TOOL -- erase "--port /dev/ttyACM0 erase-flash"
abbr --command $ESP_TOOL -- flash "--port /dev/ttyACM0 write-flash 0 "

abbr tarz 'tar --zstd'

abbr sysc 'systemctl --user'
abbr ssysc 'sudo systemctl'

abbr ai opencode
abbr oc opencode
abbr --command opencode -- ask --agent codebase --prompt
abbr ask opencode --agent codebase --prompt

if test "$TERM" = alacritty
    abbr itty alacritty &>/dev/null &
else if test "$TERM" = xterm-kitty
    abbr itty kitty &>/dev/null &
    abbr klayout kitty @ goto-layout
    abbr knew kitty @ launch
    abbr kls 'kitty @ ls | jless'
    abbr kt kitten
    abbr icat kitten icat
end

abbr --set-cursor pyimport -- uv python -c "import % as x; print(x.__path__)"

abbr dpkgi 'sudo dpkg -i '

abbr letsid lets install --dry-run
abbr letsi lets install
abbr flathub flatpak install --or-update flathub
abbr remake 'make clean && make'

abbr ksh "kitten ssh"
abbr kc "kitten choose-files --mode=files"
function kitten_cd_helper
    echo "cd "(dirname (kitten choose-files))
end
abbr -a kd --function kitten_cd_helper

# FIXME:
abbr --set-cursor=! in "$(string join -n -- 'cd !;' 'and ;' 'and cd -')"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

ulimit -Sn (ulimit -Hn)

# source .env
envsource $HOME/.env

test -e /tmp/.tio
or mkdir /tmp/.tio

##################################
# Run other configs
##################################

for file in $FISH_CONFIG_PATH.d/*.fish
    source $file
end

for file in $FISH_CONFIG_DIR/abbrs/*.fish
    source $file
end
