_: {
  fileSystems."/persist".neededForBoot = true;

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
  };
}
