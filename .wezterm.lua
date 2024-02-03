-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'
config.default_cursor_style = 'SteadyBar'

config.font = wezterm.font_with_fallback {
    -- 'Jetbrains Mono',
    -- 'Geist Mono',
    -- 'Zed Mono',
    -- 'Menlo',
    'Berkeley Mono',
    -- 'Monaco',
    -- 'Martian Mono',
    'nonicons',
    -- 'Symbols Nerd Font',
}

config.font_size = 15.0
config.line_height = 1.618
-- config.line_height = 1.3
config.hide_tab_bar_if_only_one_tab = true

config.use_fancy_tab_bar = false
config.enable_scroll_bar = false
config.window_decorations = "RESIZE"

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"

config.colors = {}
config.colors.background = '#111111'

-- and finally, return the configuration to wezterm
return config
