{ osConfig, lib, pkgs, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.email.enable) {
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
  home.packages = with pkgs; [
    protonmail-desktop
  ];
}
