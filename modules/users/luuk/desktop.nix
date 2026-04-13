{ config, ... }:
{
  imports = [ ./base.nix ];

  users.users.${config.cfg.user} = {
    hashedPasswordFile = config.sops.secrets.laptop-luuk-password.path;
  };
}
