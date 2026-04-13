{ config, lib, ... }:
{
  config = lib.mkIf config.cfg.networking.nftables.enable {
    networking.nftables.enable = true;
  };
}
