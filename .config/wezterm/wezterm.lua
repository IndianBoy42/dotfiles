local wezterm = require 'wezterm';

font = "FiraCode Nerd Font Mono"

keybindings = {{
    key = "h",
    mods = "LEADER",
    action = wezterm.action {
        SplitHorizontal = {
            domain = "CurrentPaneDomain"
        }
    }
}, {
    key = "v",
    mods = "LEADER",
    action = wezterm.action {
        SplitVertical = {
            domain = "CurrentPaneDomain"
        }
    }
}, {
    key = "t",
    mods = "LEADER|CTRL",
    action = {
        SpawnTab = "CurrentPaneDomain"
    }
}, {
    key = "UpArrow",
    mods = "LEADER|CTRL",
    action = wezterm.action {
        ScrollToPrompt = -1
    }
}, {
    key = "DownArrow",
    mods = "LEADER|CTRL",
    action = wezterm.action {
        ScrollToPrompt = 1
    }
}, {
    key = "w",
    mods = "LEADER|CTRL",
    action = {
        CloseCurrentTab = {
            confirm = true
        }
    }
}, {
    key = ",",
    mods = "LEADER|CTRL",
    action = {
        ActivateTabRelative = -1
    }
}, {
    key = ".",
    mods = "LEADER|CTRL",
    action = {
        ActivateTabRelative = 1
    }
}, {
    key = "Tab",
    mods = "LEADER|CTRL",
    action = {
        ActivateTabRelative = 1
    }
}, {
    key = "h",
    mods = "LEADER|CTRL",
    action = {
        ActivatePaneDirection = "Left"
    }
}, {
    key = "j",
    mods = "LEADER|CTRL",
    action = {
        ActivatePaneDirection = "Down"
    }
}, {
    key = "k",
    mods = "LEADER|CTRL",
    action = {
        ActivatePaneDirection = "Up"
    }
}, {
    key = "l",
    mods = "LEADER|CTRL",
    action = {
        ActivatePaneDirection = "Right"
    }
}, {
    key = "y",
    mods = "LEADER|CTRL",
    action = {
        AdjustPaneSize = {"Left", 1}
    }
}, {
    key = "u",
    mods = "LEADER|CTRL",
    action = {
        AdjustPaneSize = {"Down", 1}
    }
}, {
    key = "i",
    mods = "LEADER|CTRL",
    action = {
        AdjustPaneSize = {"Up", 1}
    }
}, {
    key = "o",
    mods = "LEADER|CTRL",
    action = {
        AdjustPaneSize = {"Right", 1}
    }
}}

return {
    font = wezterm.font_with_fallback({font}),
    -- font_rules = {
    --	{intensity="Bold", font = wezterm.font_with_fallback({font..", Bold", font})},
    --	{intensity="Half", font = wezterm.font_with_fallback({font..", Light", font})}
    -- },
    font_size = 11.0,
    leader = {
        key = "a",
        mods = "CTRL",
        timeout_milliseconds = 1000
    },
    keys = keybindings,
    unix_domains = {{
        name = "main",
    }}
}
