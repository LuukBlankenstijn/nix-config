{ ... }:
{
  imports = [
    ./config.nix
    ./secrets.nix
    ./desktop
    ./server.nix
    ./networking
    ./services
    ./persistence.nix
    ./users/luuk/desktop.nix
    ./storage/zfs.nix
  ];
}
