{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- Pull in the wezterm API
      local wezterm = require 'wezterm'
      local act = wezterm.action

      -- This will hold the configuration.
      local config = wezterm.config_builder()

      config.automatically_reload_config = true

      config.font = wezterm.font_with_fallback({
        "0xProto Nerd Font Mono",
        "JetBrains Mono",
      })

      config.window_decorations = "RESIZE"
      config.window_background_opacity = 0.5
      config.macos_window_background_blur = 20

      config.hide_tab_bar_if_only_one_tab = true

      config.font_size = 15.0

      config.color_scheme = 'Kanagawa (Gogh)'
      -- config.color_scheme = 'Bamboo Multiplex'
      -- config.color_scheme = 'Tomorrow Night'

      config.window_close_confirmation = 'NeverPrompt'

      config.keys = {
        -- Open New Pane Vert/Hori
        { key = 'Enter', mods = 'CMD|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },
        { key = '|', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },

        -- Resize Pane
        { key = 'a', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Left', 5 },},
        { key = 's', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Down', 5 },},
        { key = 'w', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
        { key = 'd', mods = 'CMD|SHIFT', action = act.AdjustPaneSize { 'Right', 5 }, },

        { key = 'r', mods = 'CMD|SHIFT', action = act.RotatePanes 'Clockwise' },

        -- Pane Navigation
        { key = 'h', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },
        { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false }, },
        { key = '[', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Prev' },
        { key = ']', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Next' },

        -- Scroll View Up/Down
        { key = 'k', mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
        { key = 'j', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
      }

      -- Performance
      config.animation_fps = 120
      config.front_end = "WebGpu"        

      -- Appearance
      config.window_padding = {
        left = '2cell',
        right = '2cell',
        top = '1.5cell',
        bottom = '1.5cell',
      }
      config.background = {
      	{
      		source = {
      			File = wezterm.home_dir .. "/Documents/Images/deer.png",
      			-- File = wezterm.home_dir .. "/Documents/Images/waves_painted.png",
      		},
          height = 'Cover',
      		width = 'Cover',
          horizontal_align = 'Center',
      	},
      	{
      		source = {
      			Color = "rgba(28, 33, 39, 0.30)",
      		},
          height = '100%',
      		width = '100%',
      	},
      }

      -- and finally, return the configuration to wezterm
      return config
    '';
  };
}
