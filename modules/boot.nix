{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.boot.splash.enable {
    boot.plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
    };

    boot.consoleLogLevel = 0;
    boot.kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
  };
}
