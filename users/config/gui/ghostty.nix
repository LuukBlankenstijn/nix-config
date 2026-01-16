_: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installVimSyntax = true;
    systemd.enable = true;
    settings = {
      theme = "Snazzy";
      bell-features = "no-audio";
      window-show-tab-bar = "never";
      cursor-color = "cell-foreground";
      cursor-text = "cell-background";
      confirm-close-surface = false;
      mouse-scroll-multiplier = "1";
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+w=toggle_tab_overview"
        "ctrl+x=close_surface"

        # Navigate splits
        "ctrl+alt+h=goto_split:left"
        "ctrl+alt+j=goto_split:down"
        "ctrl+alt+k=goto_split:up"
        "ctrl+alt+l=goto_split:right"

        # navigate tabs
        "ctrl+shift+h=previous_tab"
        "ctrl+shift+l=next_tab"

        # Resize splits
        "super+ctrl+shift+j=resize_split:down,10"
        "super+ctrl+shift+l=resize_split:left,10"
        "super+ctrl+shift+h=resize_split:right,10"
        "super+ctrl+shift+k=resize_split:up,10"
      ];
    };
  };
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "$terminal"
    ];

    "$terminal" = "ghostty";

    windowrulev2 = [
      "workspace 1, class:(com.mitchellh.ghostty)"
    ];

    bind = [
      "$mainmod, Q, exec, $terminal"
    ];
  };

}
