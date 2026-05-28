{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (osConfig.cfg) userConfig;

  osc52-copy = pkgs.writeShellScriptBin "osc52-copy" ''
    if [ -n "$TMUX" ]; then
      printf "\033Ptmux;\033\033]52;c;$(base64 | tr -d '\n')\007\033\\"
    else
      printf "\033]52;c;$(base64 | tr -d '\n')\a"
    fi
  '';
in
mkIf (userConfig.clipboard.enable || userConfig.clipboard.history.enable) {
  home.packages = mkMerge [
    (mkIf userConfig.clipboard.enable [
      pkgs.wl-clipboard
      pkgs.xclip
      osc52-copy
    ])
    (mkIf (userConfig.desktop.enable && userConfig.clipboard.history.enable) [
      pkgs.cliphist
      pkgs.fuzzel
    ])
  ];

  services.cliphist = mkIf (userConfig.desktop.enable && userConfig.clipboard.history.enable) {
    enable = true;
  };

  programs.fuzzel = mkIf (userConfig.desktop.enable && userConfig.clipboard.history.enable) {
    enable = true;
    settings = {
      main = {
        font = "GeistMono Nerd Font:size=10";
        terminal = "${pkgs.ghostty}/bin/ghostty";
        width = 40;
        horizontal-pad = 10;
        vertical-pad = 10;
        inner-pad = 5;
        line-height = 16;
        fields = "filename,name,generic";
      };
      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        border = "b4befeff";
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };

  wayland.windowManager.hyprland.settings.bind =
    mkIf (userConfig.desktop.enable && userConfig.clipboard.history.enable)
      [
        {
          _args = [
            (lib.generators.mkLuaInline ''mainmod .. " + H"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${pkgs.cliphist}/bin/cliphist-fuzzel-img")'')
          ];
        }
      ];
}
