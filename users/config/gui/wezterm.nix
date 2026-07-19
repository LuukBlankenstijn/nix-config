{ osConfig, lib, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.terminal.enable) {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local act = wezterm.action
      local config = wezterm.config_builder()

      -- theme = "Snazzy"
      config.color_scheme = "Snazzy"

      -- bell-features = "no-audio"
      config.audible_bell = "Disabled"

      -- window-show-tab-bar = "never"
      config.enable_tab_bar = false

      -- cursor-color = "cell-foreground" / cursor-text = "cell-background"
      config.force_reverse_video_cursor = true

      -- confirm-close-surface = false
      config.window_close_confirmation = "NeverPrompt"

      config.keys = {
        -- performable:ctrl+c=copy_to_clipboard
        -- copy when there is a selection, otherwise pass ctrl+c through
        {
          key = "c",
          mods = "CTRL",
          action = wezterm.action_callback(function(window, pane)
            local selection = window:get_selection_text_for_pane(pane)
            if selection and selection ~= "" then
              window:perform_action(act.CopyTo("Clipboard"), pane)
              window:perform_action(act.ClearSelection, pane)
            else
              window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
            end
          end),
        },

        -- alt+w=toggle_tab_overview
        { key = "w", mods = "ALT", action = act.ShowTabNavigator },

        -- ctrl+x=close_surface
        { key = "x", mods = "CTRL", action = act.CloseCurrentPane({ confirm = false }) },

        -- Navigate splits
        { key = "h", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") },
        { key = "j", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") },
        { key = "k", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") },
        { key = "l", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") },

        -- Navigate tabs
        { key = "h", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
        { key = "l", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },

        -- Resize splits
        { key = "j", mods = "SUPER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 10 }) },
        { key = "l", mods = "SUPER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 10 }) },
        { key = "h", mods = "SUPER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 10 }) },
        { key = "k", mods = "SUPER|CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 10 }) },
      }

      return config
    '';
  };
}
