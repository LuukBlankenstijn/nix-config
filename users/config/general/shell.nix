{ ... }: {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
    silent = true;
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "multiverse-neon";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history = {
      path = "$HOME/.zsh_history";
      size = 100000;
      save = 100000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };
    syntaxHighlighting.enable = true;
    antidote = {
      enable = true;
      plugins = [
        "getantidote/use-omz"
        "ohmyzsh/ohmyzsh path:lib"

        "ohmyzsh/ohmyzsh path:themes/robbyrussell.zsh-theme"

        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "ohmyzsh/ohmyzsh path:plugins/ssh-agent"
      ];
    };
    shellAliases = { ls = "ls -Ahl"; };
  };
}
