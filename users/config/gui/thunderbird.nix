{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
  home.packages = with pkgs; [
    protonmail-desktop
  ];
}
