{ config, lib, pkgs, ... }:
lib.mkMerge [
  (lib.mkIf config.cfg.virtualisation.docker.enable {
    virtualisation.docker.enable = true;

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/docker"
      ];
    };
  })

  (lib.mkIf config.cfg.virtualisation.libvirtd.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/libvirt"
      ];
    };
  })

  (lib.mkIf config.cfg.virtualisation.virtManager.enable {
    programs.virt-manager.enable = true;
  })

  (lib.mkIf config.cfg.virtualisation.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = config.cfg.virtualisation.podman.dockerAlias;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/containers"
      ];
    };
  })
]
