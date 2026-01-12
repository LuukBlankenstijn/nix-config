{ pkgs, lib, ... }:
let
  get-pass = pkgs.writeShellScriptBin "get-pass" ''
    ENTRY_NAME="$1"
    if [ -z "$ENTRY_NAME" ]; then exit 1; fi
    PASSWORD=$(${pkgs.rbw}/bin/rbw get "$ENTRY_NAME" 2>/dev/null)
    if [ -z "$PASSWORD" ]; then
        PASSWORD=$(printf "SETTITLE Manual Fallback\nSETDESC Password for '$ENTRY_NAME' not found in rbw\nSETPROMPT Password:\nGETPIN\n" | ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 | ${pkgs.gnugrep}/bin/grep -E "^D " | ${pkgs.coreutils}/bin/cut -c3-)
    fi
    echo -n "$PASSWORD"
  '';
in
{
  options.get-pass = lib.mkOption {
    type = lib.types.package;
    default = get-pass;
  };
  config = {
    home.packages = [
      pkgs.libsecret
      get-pass
    ];

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
