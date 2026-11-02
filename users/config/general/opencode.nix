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
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.opencode.override (prev: {
        node_modules = prev.node_modules.override {
          hash = "sha256-+GgLX4lq8fPOJVoDGp220uiCTLB0ZwrBkcNo36q9MZU=";
        };
      });
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
