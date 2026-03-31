{ config, lib, ... }:
lib.mkIf config.cfg.desktop.hardware.enable {
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
