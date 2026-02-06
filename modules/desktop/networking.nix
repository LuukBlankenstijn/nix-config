_: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
      };
    };
    wireless.iwd.enable = true;
  };

  environment.persistence."/persist".directories = [
    "/etc/NetworkManager/system-connections"
  ];
}
