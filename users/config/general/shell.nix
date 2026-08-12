{
  osConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf osConfig.cfg.userConfig.shell.enable {
  home.packages = [ pkgs.tirith ]
    ++ lib.optional osConfig.cfg.userConfig.shell.inshellisense.enable pkgs.inshellisense;

  # `is` stores its completion specs + a version marker under ~/.inshellisense and
  # bails on launch ("resources out of date, run is reinit") when version.txt does
  # not match the packaged binary. `is init` won't refresh an existing (stale)
  # copy, and `is reinit` renders an interactive UI that isn't safe to run
  # headless — so wipe the dir and let `is init` re-unpack cleanly on every
  # activation, keeping it in lockstep with the binary across updates. `|| true`
  # so a hiccup here never fails the whole switch.
  home.activation = lib.mkIf osConfig.cfg.userConfig.shell.inshellisense.enable {
    inshellisenseUnpack = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run rm -rf "$HOME/.inshellisense"
      run ${pkgs.inshellisense}/bin/is init zsh > /dev/null 2>&1 || true
    '';
  };

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

    oh-my-posh =
      let
        themeName = if osConfig.cfg.desktop.enable then "multiverse-neon" else "blue-owl";
        baseTheme = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile
          "${pkgs.oh-my-posh}/share/oh-my-posh/themes/${themeName}.omp.json"));
        sshBlock = {
          type = "prompt";
          alignment = "left";
          segments = [{
            type = "session";
            style = "plain";
            background = "#FFAB40";
            foreground = "#1a1a1a";
            template = "{{ if .SSHSession }}  {{ .HostName }} {{ end }}";
          }];
        };
        stripSessionFromRight = builtins.map (b:
          if (b.alignment or "") == "right" && (b.type or "") == "prompt"
          then b // { segments = builtins.filter (s: (s.type or "") != "session") b.segments; }
          else b
        );
      in
      {
        enable = true;
        enableZshIntegration = true;
        settings = baseTheme // {
          blocks = [ sshBlock ] ++ (stripSessionFromRight baseTheme.blocks);
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
          "ohmyzsh/ohmyzsh path:themes/robbyrussell.zsh-theme"
          "ohmyzsh/ohmyzsh path:plugins/git"
        ];
      };
      shellAliases = {
        ls = "ls -Ahl";
      };
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          DISABLE_AUTO_UPDATE="true"
          eval "$(${pkgs.tirith}/bin/tirith init --shell zsh)"
        '')
        # inshellisense hands the interactive shell off to `is`, which re-spawns
        # zsh inside its autocomplete runtime. ISTERM is set inside that session
        # so the nested shell skips this guard instead of recursing. Kept last in
        # the init as upstream requires.
        #
        # `is` refuses to start unless its resources are unpacked into
        # ~/.inshellisense (done by the activation step below), so we only hand
        # off once version.txt exists, and use `&&` rather than `;` so a failing
        # `is` falls through to a normal shell instead of exiting it — otherwise a
        # broken/outdated install would close every terminal on launch.
        (lib.mkIf osConfig.cfg.userConfig.shell.inshellisense.enable (lib.mkAfter ''
          if [[ -z "''${ISTERM}" && "$-" = *i* && "$-" != *c* && -z "''${VSCODE_RESOLVING_ENVIRONMENT}" && -f "''${HOME}/.inshellisense/version.txt" ]]; then
            if [[ -o login ]]; then
              ${pkgs.inshellisense}/bin/is -s zsh --login && exit
            else
              ${pkgs.inshellisense}/bin/is -s zsh && exit
            fi
          fi
        ''))
      ];
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
