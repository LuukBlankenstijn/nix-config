{ config, lib, pkgs, ... }:
lib.mkMerge [
  (lib.mkIf config.cfg.virtualisation.docker.enable {
    virtualisation.docker.enable = true;

    environment.persistence."/persist".directories = lib.mkIf config.cfg.impermanence.enable [
      "/var/lib/docker"
    ];
  })

  (lib.mkIf config.cfg.virtualisation.libvirtd.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };

    environment.persistence."/persist".directories = lib.mkIf config.cfg.impermanence.enable [
      "/var/lib/libvirt"
    ];
  })

  (lib.mkIf config.cfg.virtualisation.virtManager.enable {
    programs.virt-manager.enable = true;
  })
]
