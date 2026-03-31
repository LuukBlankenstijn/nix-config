{ osConfig, lib, inputs, pkgs, ... }:
{
  imports = [ inputs.hyprshell.homeModules.hyprshell ];

  config = lib.mkIf (osConfig.cfg.userConfig.desktop.hyprland.enable && osConfig.cfg.userConfig.desktop.hyprland.shell.enable) {
    programs.hyprshell = {
      enable = true;
      package = pkgs.hyprshell;
      systemd.enable = true;
      systemd.args = "-v";
      settings = {
        windows = {
          enable = true;
          items_per_row = 3;
          overview = {
            enable = true;
            key = "r";
            modifier = "super";
            launcher = {
              max_items = 6;
            };
          };
          switch = {
            # TODO: enable again when hyprshell supports filtering special workspaces
            # https://github.com/H3rmt/hyprshell/issues/403
            enable = false;
            filter_by = [ ];
          };
        };
      };
    };
  };
}
