{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
lib.mkIf (osConfig.cfg.userConfig.desktop.enable && osConfig.cfg.userConfig.desktop.claudeDesktop.enable) {
  home.packages = [
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
