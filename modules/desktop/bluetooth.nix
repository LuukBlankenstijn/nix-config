{ config, lib, ... }:
lib.mkIf config.cfg.bluetooth.enable {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  environment.persistence."/persist".directories = lib.mkIf config.cfg.impermanence.enable [
    "/etc/bluetooth"
    "/var/lib/bluetooth"
  ];
}
