{ config, lib, ... }:
lib.mkIf config.cfg.bluetooth.enable {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.pipewire.wireplumber.extraConfig."51-bluez-no-autoswitch" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
    directories = [
      "/etc/bluetooth"
      "/var/lib/bluetooth"
    ];
  };
}
