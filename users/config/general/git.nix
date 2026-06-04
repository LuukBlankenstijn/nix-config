{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  gitCfg = osConfig.cfg.userConfig.git;
in
lib.mkIf gitCfg.enable {
  programs.git = {
    enable = true;
    ignores = [ ".direnv/" ];
    settings = lib.recursiveUpdate {
      user = {
        name = "Luuk Blankenstijn";
        email = "git@luukblankenstijn.nl";
      };
      signing = {
        format = "ssh";
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
        signer = "${pkgs.openssh}/bin/ssh-keygen";
      };
      core.autocrlf = false;
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      fetch.prune = true;
    } gitCfg.extraSettings;

    includes = lib.mapAttrsToList (condition: contents: {
      inherit condition contents;
    }) gitCfg.dirSettings;
  };
}
