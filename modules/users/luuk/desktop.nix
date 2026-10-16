{ config, lib, ... }:
{
  imports = [ ./base.nix ];

  users.users.${config.cfg.user} = {
    hashedPasswordFile = lib.mkIf config.cfg.secrets.password.enable config.sops.secrets.password.path;
  };
}
