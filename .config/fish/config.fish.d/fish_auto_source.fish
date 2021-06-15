# adapted from
# https://github.com/fish-shell/fish-shell/issues/5707#issuecomment-467331991

function auto_source --on-event fish_prompt -d 'auto source config.fish if gets modified!'
    set -q FISH_CONFIG_DIR && set -x FISH_CONFIG_PATH "$FISH_CONFIG_DIR/config.fish"
    if set -q FISH_CONFIG_PATH
        set -l fish_config_time_new (date -r $FISH_CONFIG_PATH)
        if ! set -q FISH_CONFIG_TIME
            set -g FISH_CONFIG_TIME $fish_config_time_new
        else
            if test "$FISH_CONFIG_TIME" != "$fish_config_time_new"
                set FISH_CONFIG_TIME $fish_config_time_new
                source $FISH_CONFIG_PATH
            end
        end
    end
    if set -q FISH_CONFIG_DIR

    end
end

auto_source
abbr profile "$EDITOR $FISH_CONFIG_PATH"
