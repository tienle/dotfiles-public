local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = 'Tomorrow Night Bright (Gogh)'

config.default_prog = { "/opt/homebrew/bin/zsh", "--login" }


config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12
config.line_height = 1
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.native_macos_fullscreen_mode = true
-- tab bar
config.tab_bar_at_bottom = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_max_width = 200
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

config.use_dead_keys = false
config.unix_domains = { { name = "unix" } }

config.mouse_bindings = {
  -- Open URLs with Ctrl+Click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  }
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = { -- Copy mode
  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action { SendString = "\x1b\r" },
  },
  {
    key = "f",
    mods = "CTRL|CMD",
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = "t",
    mods = "CMD",
    action = wezterm.action.SpawnCommandInNewTab({
      cwd = wezterm.home_dir,
    }),
  },
  -- Create a tab (alternative to Ctrl-Shift-Tab)
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  -- Vertical split
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitPane {
      direction = 'Right',
      size = { Percent = 50 },
    },
  },
  -- Horizontal split
  {
    -- -
    key = '-',
    mods = 'LEADER',
    action = act.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey({ key = 'a', mods = 'CTRL' }),
  },
  -- CTRL-a, followed by a will switch back to the last active tab
  {
    key = 'a',
    mods = 'LEADER',
    action = wezterm.action.ActivateLastTab,
  },
  {
    key = "{",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "}",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "{",
    mods = "OPT|SHIFT",
    action = wezterm.action.RotatePanes("CounterClockwise"),
  },
  {
    key = "}",
    mods = "OPT|SHIFT",
    action = wezterm.action.RotatePanes("Clockwise"),
  },
  -- Move to next/previous TAB
  {
    key = 'n',
    mods = 'LEADER',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateTabRelative(-1),
  },
  -- Close tab
  {
    key = '&',
    mods = 'LEADER|SHIFT',
    action = act.CloseCurrentTab { confirm = true },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.ShowTabNavigator,
  },
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- move between panels
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Up') },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Down') },
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Left') },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Right') },
  -- Close/kill active pane
  {
    key = 'x',
    mods = 'LEADER',
    action = act.CloseCurrentPane { confirm = true },
  },
  -- Zoom current pane (toggle)
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
}

for i = 1, 9 do
  -- CTRL+number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

return config
