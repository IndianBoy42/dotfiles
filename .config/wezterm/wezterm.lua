local wezterm = require 'wezterm';

font = "FiraCode Nerd Font Mono"

return {
    font = wezterm.font_with_fallback({font}),
    --font_rules = {
    --	{intensity="Bold", font = wezterm.font_with_fallback({font..", Bold", font})},
    --	{intensity="Half", font = wezterm.font_with_fallback({font..", Light", font})}
    --},
    font_size = 11.0,
    leader = { key="a", mods="CTRL", timeout_milliseconds=1000 },
    keys = {
    	{key="h", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    	{key="v", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}}
    }
}
