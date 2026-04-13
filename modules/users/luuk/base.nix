{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.${config.cfg.user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "seat"
      "wheel"
    ]
    ++ lib.optionals config.cfg.networking.enable [ "networkmanager" ]
    ++ lib.optionals config.cfg.virtualisation.docker.enable [ "docker" ]
    ++ lib.optionals config.cfg.virtualisation.libvirtd.enable [ "libvirtd" ];
  };
}
