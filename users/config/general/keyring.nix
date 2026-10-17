{ osConfig, lib, pkgs, ... }:
lib.mkIf osConfig.cfg.userConfig.desktop.enable {
  services.gnome-keyring.enable = true;
  home.packages = [
    pkgs.gcr_3
    pkgs.libsecret
  ];
}
