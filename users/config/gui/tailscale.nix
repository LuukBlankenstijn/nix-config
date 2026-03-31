{ osConfig, lib, ... }:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.tailscale.enable) {
  services.tailscale-systray.enable = true;
}
