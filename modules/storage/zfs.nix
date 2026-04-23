{ config, lib, pkgs, ... }:
lib.mkIf config.cfg.impermanence.enable {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.package = pkgs.zfs;
  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-partlabel/disk-main-luks";
  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback ZFS root to blank snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-rpool.service" ];
    before = [ "sysroot.mount" ];
    path = [ pkgs.zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      if zfs list -H -t snapshot -o name rpool/root@blank >/dev/null 2>&1; then
        zfs rollback -r rpool/root@blank
      fi
    '';
  };

  services.zfs.autoScrub.enable = true;
  environment.systemPackages = [ pkgs.zfs ];

  systemd.services.zfs-create-blank-snapshot = {
    description = "Create baseline ZFS snapshot for rollback";
    wantedBy = [ "multi-user.target" ];
    after = [ "zfs-mount.service" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.zfs ];
    script = ''
      if ! zfs list -H -t snapshot -o name rpool/root@blank >/dev/null 2>&1; then
        zfs snapshot rpool/root@blank
      fi
    '';
  };
}
