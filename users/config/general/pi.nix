{
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
{
  imports = [ inputs.pi.homeManagerModules.default ];

  config.programs.pi-coding-agent = lib.mkIf osConfig.cfg.userConfig.pi.enable {
    enable = true;
    package = inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.pi-coding-agent-src;

    extraEnv = {
      PATH = lib.makeBinPath [
        pkgs.fd
        pkgs.ripgrep
      ];
      PI_SKIP_VERSION_CHECK = "1";
    };

    agentFiles.settings.value = {
      theme = "dark";
      externalEditor = "nvim";
      quietStartup = true;
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      packages = [
        "npm:pi-mcp-adapter@2.32.1"
        "npm:pi-web-access@0.28.0"
        "npm:pi-subagents@0.66.0"
        "npm:@juicesharp/rpiv-ask-user-question@2.9.0"
        "npm:pi-background-tasks@2.5.0"
      ];
    };
  };
}
