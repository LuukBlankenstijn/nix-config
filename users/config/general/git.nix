{
  osConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf osConfig.cfg.userConfig.git.enable {
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
    } osConfig.cfg.userConfig.git.extraSettings;
  };
}
