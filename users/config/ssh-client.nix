{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;

        extraOptions = { "AddKeysToAgent" = "yes"; };
      };
    };
  };
}

