{ config, lib, ... }:
lib.mkIf config.cfg.desktop.printing.enable {
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
