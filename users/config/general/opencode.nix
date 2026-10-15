{
  lib,
  pkgs,
  config,
  osConfig,
  inputs,
  ...
}:
{
  config = lib.mkIf osConfig.cfg.userConfig.opencode.enable {
    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode.overrideAttrs {
        # https://github.com/anomalyco/opencode/issues/55491: upstream src fileset omits script/; drop once #55494 ships.
        src = inputs.opencode;
      };
      settings = {
        autoupdate = false;
        share = "disabled";
        plugins = [
          "@ex-machina/opencode-anthropic-auth@next"
        ];
      };
    };

    xdg.configFile."opencode/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.omp/agent/AGENTS.md";
  };
}
