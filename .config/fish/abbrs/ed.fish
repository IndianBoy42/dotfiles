abbr -a --command $EDITOR -- ,yad '(yadm tracked ~ | fzf --multi --preview=\'bat {}\')'
abbr -a --command $EDITOR -- ,cfg ~/.config/'(fzf --multi --walker-root ~/.config --preview=\'bat {}\')'
abbr -a --command $EDITOR --command cd --command z -- ,conf ~/.config/
abbr --set-cursor -a --command $EDITOR -- ,fish '$FISH_CONFIG_DIR/% && source $FISH_CONFIG_PATH'
abbr -a --command $EDITOR --command cd --command z -- ,nvim ~/.config/nvim/
abbr -a --command $EDITOR --command cd --command z -- ,oc ~/.config/opencode/
abbr -a --command $EDITOR --command cd --command z -- ,qmk ~/qmk_userspace/
abbr -a --command $EDITOR -- ,jj ~/.config/jj/
abbr -a --command $EDITOR -- ,git ~/.gitconfig
abbr -a --command $EDITOR -- ,kty '~/.config/kitty/kitty.conf && kill -SIGUSR1 $KITTY_PID'
abbr -a --command $EDITOR -- ,ig './.*ignore'
abbr -a --command $EDITOR -- ,cg ~/.cargo/config.toml .cargo/config.toml
