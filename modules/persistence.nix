{ config, lib, ... }:
lib.mkIf config.cfg.impermanence.enable {
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/ssh"
      "/var/lib/systemd/coredump"
      "/var/log"
      {
        directory = "/home/${config.cfg.user}";
        user = config.cfg.user;
        group = config.users.users.${config.cfg.user}.group;
        mode = "0700";
      }
    ];
    files = [
      "/etc/machine-id"
      "/etc/adjtime"
    ];
  };
}
