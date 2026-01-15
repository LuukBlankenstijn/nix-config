{ config, ... }:
{
  imports = [ ./base.nix ];

  users.users.luuk = {
    hashedPasswordFile = config.sops.secrets.laptop-luuk-password.path;
    extraGroups = [
      "docker"
      "libvirtd"
      "networkmanager"
    ];
  };

  environment.persistence."/persist".users.luuk.directories = [ "." ];
}
