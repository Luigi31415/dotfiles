local wezterm = require("wezterm")

-- Config builder setup
local config = wezterm.config_builder()
local act = wezterm.action

-- General appearance and behavior
config.color_scheme = "Catppuccin Macchiato"
config.audible_bell = "Disabled"
config.font_size = 20
config.window_decorations = "RESIZE"

-- Padding: edge space inside the terminal window
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Key bindings
config.keys = {
	-- Resize pane
	{
		key = "H",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},

	-- Word-wise cursor navigation (macOS)
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({ key = "b", mods = "ALT" }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},

	-- Jump to line start/end
	{
		key = "LeftArrow",
		mods = "SUPER",
		action = act.SendKey({ key = "Home" }),
	},
	{
		key = "RightArrow",
		mods = "SUPER",
		action = act.SendKey({ key = "End" }),
	},

	-- Move tabs
	{
		key = "1",
		mods = "SUPER",
		action = act.MoveTabRelative(-1),
	},
	{
		key = "2",
		mods = "SUPER",
		action = act.MoveTabRelative(1),
	},
	{
		key = "Tab",
		mods = "CTRL",
		action = wezterm.action.ActivateLastTab,
	},
	-- {
	-- 	key = "0",
	-- 	mods = "CTRL",
	-- 	action = wezterm.action.ActivateTabRelative(1),
	-- },
	-- {
	-- 	key = "0",
	-- 	mods = "CTRL|CMD",
	-- 	action = wezterm.action.ShowTabNavigator,
	-- },
	{
		key = "Tab",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

-- Return the finalized configuration
return config
