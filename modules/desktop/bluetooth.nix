{ ... }: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  environment.persistence."/persist".directories = [
    "/etc/bluetooth"
    "/var/lib/bluetooth"
  ];
}
