{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.keyring.enable) {
  home.packages = [ pkgs.seahorse ];
}
