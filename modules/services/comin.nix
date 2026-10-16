{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.services.comin.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/LuukBlankenstijn/nix-config.git";
          branches = {
            main.name = "main";
            testing.name = "";
          };
        }
      ];
    };

    environment.persistence."/persist" = mkIf config.cfg.impermanence.enable {
      directories = [ "/var/lib/comin" ];
    };
  };
}
