{
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  omp = pkgs.symlinkJoin {
    name = "omp-with-chromium";
    paths = [ inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/omp \
        --set-default PUPPETEER_EXECUTABLE_PATH ${lib.getExe pkgs.chromium}
    '';
  };
in
{
  imports = [ inputs.omp.homeManagerModules.default ];

  config.programs.omp = lib.mkIf osConfig.cfg.userConfig.omp.enable {
    enable = true;
    package = omp;

    settings = {
      setupVersion = 2;
      modelRoles = {
        default = "anthropic/claude-opus-5";
        plan = "anthropic/claude-opus-4-8";
        task = "anthropic/claude-opus-4-8";
        slow = "anthropic/claude-opus-4-8";
        advisor = "anthropic/claude-opus-4-8";
        smol = "anthropic/claude-opus-4-7:medium";
        commit = "ollama/qwen3.5:4b-q4_K_M";
      };
      defaultThinkingLevel = "auto";
      hideThinkingBlock = true;
      steeringMode = "all";
      interruptMode = "immediate";
      memory.backend = "mnemopi";
      edit.mode = "hashline";
      checkpoint.enabled = true;
      github.enabled = true;
      secrets.enabled = true;
      advisor = {
        enabled = true;
        syncBacklog = "off";
      };
      bash.autoBackground.enabled = true;
      task.agentAdvisor.task = "on";
      composer.shape = "borderless";
      dev.autoqaConsent = "granted";
    };
  };
}
