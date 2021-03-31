local wezterm = require 'wezterm';
return {
    font = wezterm.font("FiraCode Nerd Font Mono"),
    leader = { key="a", mods="CTRL", timeout_milliseconds=1000 },
    keys = {
    	{key="h", mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    	{key="v", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}}
    }
}
