{
  osConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf osConfig.cfg.userConfig.shell.enable {
  home.packages = [ pkgs.tirith ];

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = if osConfig.cfg.desktop.enable then "multiverse-neon" else "blue-owl";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
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
        ]
        ++ lib.optionals osConfig.cfg.desktop.enable [
          "ohmyzsh/ohmyzsh path:plugins/ssh-agent"
        ];
      };
      shellAliases = {
        ls = "ls -Ahl";
      };
      initContent = ''
        eval "$(${pkgs.tirith}/bin/tirith init --shell zsh)"
      '';
    };
  };
}
