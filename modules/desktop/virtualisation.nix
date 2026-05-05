{
  config,
  lib,
  pkgs,
  ...
}:
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

    environment.etc."qemu/bridge.conf".text = ''
      allow virbr0
    '';

    environment.persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
      directories = [
        "/var/lib/systemd"
        "/var/lib/libvirt"
      ];
    };
  })

  (lib.mkIf config.cfg.virtualisation.virtManager.enable {
    programs.virt-manager.enable = true;
  })

  (lib.mkIf config.cfg.virtualisation.podman.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat =
          (!config.cfg.virtualisation.docker.enable) && config.cfg.virtualisation.podman.dockerAlias;
        dockerSocket.enable = !config.cfg.virtualisation.docker.enable;
        defaultNetwork.settings.dns_enabled = true;
      };

      containers.containersConf.settings = {
        engine = {
          compose_warning_logs = false;
        };
      };
    };

    environment = {

      systemPackages = [
        pkgs.podman-compose
      ];

      persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
        directories = [
          "/var/lib/containers"
        ];
      };
    };
  })
]
