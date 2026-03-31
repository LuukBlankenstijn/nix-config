{ ... }:
{
  imports = [
    ./myconfig.nix
    ./secrets.nix
    ./desktop
    ./storage/zfs.nix
    ./users/luuk/desktop.nix
  ];
}
