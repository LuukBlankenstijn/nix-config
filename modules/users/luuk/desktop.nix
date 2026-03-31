{ config, lib, ... }:
{
  imports = [ ./base.nix ];

  users.users.${config.cfg.user} = {
    hashedPasswordFile = config.sops.secrets.laptop-luuk-password.path;
    extraGroups =
      lib.optionals config.cfg.networking.enable [ "networkmanager" ]
      ++ lib.optionals config.cfg.virtualisation.docker.enable [ "docker" ]
      ++ lib.optionals config.cfg.virtualisation.libvirtd.enable [ "libvirtd" ];
  };

  environment.persistence."/persist".users.${config.cfg.user} = lib.mkIf config.cfg.impermanence.enable {
    directories = [
      { directory = ""; }
    ];
  };
}
