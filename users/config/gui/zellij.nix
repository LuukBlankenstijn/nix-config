{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.terminal.enable) {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      session_serialization = true;
      serialize_pane_viewport = true;
      pane_frames = false;
      default_layout = "compact";
    };
  };

  wayland.windowManager.hyprland.settings.bind =
    lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable [
      {
        _args = [
          (lib.generators.mkLuaInline ''mainmod .. " + T"'')
          (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.ghostty}/bin/ghostty -e ${pkgs.zellij}/bin/zellij attach --create main")'')
        ];
      }
    ];
}
