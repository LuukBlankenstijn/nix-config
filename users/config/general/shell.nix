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

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$username$hostname"
          "$directory"
          "$git_branch$git_status"
          "$nix_shell"
          "$cmd_duration"
          "$line_break"
          "$character"
        ];

        username = {
          show_always = false;
          format = "[$user]($style)@";
          style_user = "bold yellow";
        };

        hostname = {
          ssh_only = true;
          format = "[$hostname]($style) ";
          style = "bold yellow";
        };

        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold blue";
          read_only = " ";
        };

        git_branch.style = "bold magenta";
        git_status.style = "bold red";

        nix_shell = {
          format = "[$symbol$name]($style) ";
          symbol = " ";
          style = "bold cyan";
        };

        cmd_duration = {
          min_time = 2000;
          format = "[$duration]($style) ";
          style = "dimmed white";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
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
          "ohmyzsh/ohmyzsh path:plugins/git"
        ];
      };
      shellAliases = {
        ls = "ls -Ahl";
      };
      initContent = lib.mkBefore ''
        DISABLE_AUTO_UPDATE="true"
        eval "$(${pkgs.tirith}/bin/tirith init --shell zsh)"
      '';
      completionInit = ''
        autoload -Uz compinit
        if [[ ~/.zcompdump -ot /run/current-system ]]; then
          compinit
          touch ~/.zcompdump
        else
          compinit -C
        fi
      '';
    };

    keychain = {
      inherit (osConfig.cfg.desktop) enable;
      keys = [ "id_ed25519" ];
    };
  };
}
