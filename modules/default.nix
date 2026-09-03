{ ... }:
{
  imports = [
    ./config.nix
    ./secrets.nix
    ./boot.nix
    ./desktop
    ./server.nix
    ./networking
    ./services
    ./persistence.nix
    ./users/luuk/desktop.nix
    ./storage/zfs.nix
    ./gpg.nix
  ];
}
