{ lib, pkgs, ... }:
{
  users.users.luuk = {
    isNormalUser = true;
    extraGroups = lib.mkAfter [
      "seat"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
