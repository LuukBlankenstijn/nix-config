{ ... }: {
  programs.kitty = {
    enable = true;
    themeFile = "snazzy";
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-cursor";
    };
    settings = {
      enable_audio_bell = false;
      cursor_trail = 1;
      cursor_trail_start_threshold = 100;
      confirm_os_window_close = 0;
    };
    keybindings = { "ctrl+c" = "copy_or_interrupt"; };
  };
}
