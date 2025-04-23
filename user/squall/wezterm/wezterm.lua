-- see: https://alexplescan.com/posts/2024/08/10/wezterm/
local wezterm = require "wezterm"
local config = wezterm.config_builder()

font = wezterm.font("Nerd Fira Code")
config.color_scheme = "Catppuccin Macchiato"
config.font_size = 16.0
config.window_decorations = "RESIZE"

return config
