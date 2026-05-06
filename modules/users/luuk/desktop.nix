{ config, ... }:
{
  imports = [ ./base.nix ];

  users.users.${config.cfg.user} = {
    hashedPasswordFile = config.sops.secrets.password.path;
  };
}
