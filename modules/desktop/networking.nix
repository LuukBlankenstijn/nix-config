_: {
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  environment.persistence."/persist".directories = [
    "/etc/NetworkManager/system-connections"
  ];
}
