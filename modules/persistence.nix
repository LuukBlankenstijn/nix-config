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
    ];
    files = [
      "/etc/machine-id"
      "/etc/adjtime"
    ];
    users.${config.cfg.user} = {
      directories = [
        { directory = ""; }
      ];
    };
  };
}
