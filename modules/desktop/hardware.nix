{
  config,
  lib,
  ...
}:
lib.mkIf config.cfg.desktop.hardware.enable {
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.${config.cfg.user}.extraGroups = [
    "video"
    "render"
  ];
}
