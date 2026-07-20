{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.terminal.enable) {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local act = wezterm.action
      local config = wezterm.config_builder()

      -- session save/restore across reboots (resurrect.wezterm).
      -- Only load the plugin in the GUI process: the mux server evaluates this
      -- same config, and if both processes fetch the plugin they race on the
      -- same install directory (the "Failed to rename ... plugins/..." error).
      -- wezterm.gui is nil in the headless mux server, so this gate skips it
      -- there. The pcall guards against a failed fetch (e.g. no network on the
      -- very first launch) breaking the entire config.
      local resurrect_ok, resurrect = false, nil
      if wezterm.gui then
        resurrect_ok, resurrect = pcall(
          wezterm.plugin.require,
          "https://github.com/MLFlexer/resurrect.wezterm"
        )
        if resurrect_ok then
          -- snapshot open workspaces every 15 minutes so there is a recent
          -- state to restore after a reboot
          resurrect.state_manager.periodic_save()
        end
      end

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

      -- drop the default 8px window padding for a tight, ghostty-like look
      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      -- tmux-like session persistence: run panes inside a local mux server so
      -- they survive the GUI window closing/restarting, and connect the GUI to
      -- it on startup (reattach with `wezterm connect unix`).
      config.unix_domains = {
        { name = "unix" },
      }
      config.default_gui_startup_args = { "connect", "unix" }

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

        -- detach the GUI from the mux server, leaving the session running
        { key = "d", mods = "CTRL|ALT", action = act.DetachDomain("CurrentPaneDomain") },

        -- save the current session on demand (resurrect.wezterm)
        {
          key = "s",
          mods = "CTRL|SHIFT",
          action = wezterm.action_callback(function(win, pane)
            if not resurrect_ok then
              return
            end
            resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
            win:toast_notification("wezterm", "session saved", nil, 4000)
          end),
        },

        -- restore a previously saved session (resurrect.wezterm)
        {
          key = "r",
          mods = "CTRL|SHIFT",
          action = wezterm.action_callback(function(win, pane)
            if not resurrect_ok then
              return
            end
            resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
              local kind = string.match(id, "^([^/]+)")
              id = string.match(id, "([^/]+)$")
              id = string.match(id, "(.+)%..+$")
              local opts = {
                relative = true,
                restore_text = true,
                on_pane_restore = resurrect.tab_state.default_on_pane_restore,
              }
              if kind == "workspace" then
                local state = resurrect.state_manager.load_state(id, "workspace")
                resurrect.workspace_state.restore_workspace(state, opts)
              elseif kind == "window" then
                local state = resurrect.state_manager.load_state(id, "window")
                resurrect.window_state.restore_window(pane:window(), state, opts)
              elseif kind == "tab" then
                local state = resurrect.state_manager.load_state(id, "tab")
                resurrect.tab_state.restore_tab(pane:tab(), state, opts)
              end
            end)
          end),
        },

        -- Create splits / tabs (ghostty defaults)
        -- ctrl+shift+o=new_split:right
        { key = "o", mods = "CTRL|SHIFT", action = act.SplitPane({ direction = "Right" }) },
        -- ctrl+shift+e=new_split:down
        { key = "e", mods = "CTRL|SHIFT", action = act.SplitPane({ direction = "Down" }) },
        -- ctrl+shift+t=new_tab
        { key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },

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

  # Run the multiplexer server as a user service so terminal sessions persist
  # across GUI restarts regardless of how wezterm is launched. Connecting from
  # the GUI is supposed to auto-start it, but a bare `wezterm start` from an app
  # launcher ignores default_gui_startup_args and never spins the server up, so
  # we start it explicitly here. Runs in the foreground (no --daemonize) under
  # Type=simple, and is bound to the user session rather than the graphical
  # session so it survives compositor restarts.
  systemd.user.services.wezterm-mux-server = {
    Unit = {
      Description = "wezterm multiplexer server";
      Documentation = [ "https://wezterm.org/multiplexing.html" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wezterm}/bin/wezterm-mux-server";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # The packaged wezterm.desktop launches `wezterm start`, which opens a fresh
  # local window and ignores default_gui_startup_args, so app-launcher/menu
  # launches never attach to the mux server. Override the entry to connect to
  # the unix domain instead, so a window opened from the launcher rejoins the
  # persistent session. (`connect` auto-starts the mux server if it is not
  # already running.)
  xdg.desktopEntries."org.wezfurlong.wezterm" = {
    name = "WezTerm";
    genericName = "Terminal Emulator";
    comment = "Wez's Terminal Emulator";
    exec = "${pkgs.wezterm}/bin/wezterm connect unix";
    icon = "org.wezfurlong.wezterm";
    type = "Application";
    terminal = false;
    categories = [ "System" "TerminalEmulator" "Utility" ];
    startupNotify = true;
    settings = {
      TryExec = "${pkgs.wezterm}/bin/wezterm";
      StartupWMClass = "org.wezfurlong.wezterm";
      Keywords = "shell;prompt;command;commandline;cmd;";
    };
  };
}
