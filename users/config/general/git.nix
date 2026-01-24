_: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Luuk Blankenstijn";
        email = "git@luukblankenstijn.nl";
      };
      core.autocrlf = false;
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      fetch.prune = true;
    };
  };
}
