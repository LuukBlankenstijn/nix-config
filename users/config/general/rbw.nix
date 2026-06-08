{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  get-pass = pkgs.writeShellScriptBin "get-pass" ''
    ENTRY_NAME="$1"
    if [ -z "$ENTRY_NAME" ]; then exit 1; fi

    CACHE_FILE="/tmp/askpass-cooldown-$USER"
    NOW=$(${pkgs.coreutils}/bin/date +%s)
    if [ -f "$CACHE_FILE" ]; then
        LAST=$(${pkgs.coreutils}/bin/cat "$CACHE_FILE")
        DIFF=$((NOW - LAST))
    else
        DIFF=999
    fi
    echo "$NOW" > "$CACHE_FILE"


    # If on cooldown, skip rbw
    PASSWORD=""
    if [ "$DIFF" -gt 3 ]; then
        PASSWORD=$(${pkgs.rbw}/bin/rbw get "$ENTRY_NAME" 2>/dev/null)
    fi

    # fallback to manual input
    if [ -z "$PASSWORD" ]; then
        PASSWORD=$(printf "SETTITLE sudo password\nSETDESC Provide password for '$ENTRY_NAME'\nSETPROMPT Password:\nGETPIN\n" | \
            ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 | \
            ${pkgs.gnugrep}/bin/grep -E "^D " | \
            ${pkgs.coreutils}/bin/cut -c3-)
    fi

    echo -n "$PASSWORD"
  '';

  sudo-askpass = pkgs.writeShellScriptBin "sudo-askpass" ''
    # Replace 'system/local-user' with your actual rbw entry name
    ${get-pass}/bin/get-pass "zenbook-login"
  '';
in
{
  options.get-pass = lib.mkOption {
    type = lib.types.package;
    default = get-pass;
  };
  config = lib.mkIf osConfig.cfg.userConfig.rbw.enable {
    home.packages = [
      pkgs.libsecret
      get-pass
    ];

    home.sessionVariables = {
      SUDO_ASKPASS = "${sudo-askpass}/bin/sudo-askpass";
    };

    programs.zsh = {
      enable = true;
      initContent = ''
        if [ -z "$SSH_CONNECTION" ] && [ -z "$SSH_TTY" ]; then
          alias sudo='sudo -A'
        fi
      '';
    };

    programs.rbw = {
      enable = true;
      settings = {
        email = "luukblankenstijn@gmail.com";
        base_url = "https://vaultwarden.luukblankenstijn.nl";
        lock_timeout = 3600;
        pinentry = pkgs.pinentry-gnome3;
      };
    };
  };
}
