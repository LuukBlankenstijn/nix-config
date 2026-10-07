{ pkgs, ... }:
{
  services.gnome-keyring.enable = true;
  home.packages = [
    pkgs.gcr_3
    pkgs.libsecret
  ];
}
