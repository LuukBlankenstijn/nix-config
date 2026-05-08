{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.cfg.gpg.enable {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
