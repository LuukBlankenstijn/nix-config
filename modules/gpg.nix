{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.cfg.gpg.enable {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage =
      if config.cfg.desktop.enable then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
  };
}
