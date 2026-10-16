{ osConfig, lib, pkgs, ... }:
let
  viewers = [
    pkgs.loupe
    pkgs.papers
    pkgs.mpv
    pkgs.file-roller
  ];
in
lib.mkIf osConfig.cfg.userConfig.desktop.enable {
  home.packages = viewers;

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = viewers;
    defaultApplications."application/pdf" = "zen-beta.desktop";
  };

  xdg.configFile."mimeapps.list".enable = false;
}
