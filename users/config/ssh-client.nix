{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        AddKeysToAgent = "yes";
      };
    };
  };
}
