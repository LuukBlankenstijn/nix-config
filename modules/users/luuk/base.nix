{ config, lib, pkgs, ... }:
{
  users.users.${config.cfg.user} = {
    isNormalUser = true;
    extraGroups = lib.mkAfter [
      "seat"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
