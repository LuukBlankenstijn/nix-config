{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkDefault mkMerge;
  enabled = config.cfg.desktop.enable && config.cfg.desktop.niri.enable;
in
{
  imports = [ inputs.niri.nixosModules.niri ];

  config = mkMerge [
    { niri-flake.cache.enable = mkDefault false; }

    (mkIf enabled {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
    })
  ];
}
