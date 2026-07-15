{
  osConfig,
  lib,
  pkgs,
  config,
  ...
}:
let
  rdp = pkgs.writeShellScriptBin "rdp" ''
    export P=$(${config.get-pass}/bin/get-pass "gewis-m-account")

    RDP_ARGS=$(head -n 1 ${config.sops.secrets.rdp-arguments.path} | tr -d "\r\n")

    ${pkgs.zsh}/bin/zsh -c "${pkgs.freerdp}/bin/xfreerdp $RDP_ARGS"
  '';
in
{
  sops = {
    secrets = {
      ssh-config.sopsFile = ../../secrets/gewis.yaml;

      kerberos-config.sopsFile = ../../secrets/gewis.yaml;

      rdp-arguments.sopsFile = ../../secrets/gewis.yaml;
    };
    templates = {

      ssh-config-file = {
        path = "${config.home.homeDirectory}/.ssh/config.d/gewis";
        mode = "0600";
        content = config.sops.placeholder.ssh-config;
      };

      kerberos-config-file = {
        path = "${config.home.homeDirectory}/.krb5/config";
        content = config.sops.placeholder.kerberos-config;
      };
    };
  };

  programs.ssh = {
    extraConfig = ''
      Include ${config.sops.templates.ssh-config-file.path}
    '';
  };

  home.sessionVariables = {
    KRB5_CONFIG = "${config.home.homeDirectory}/.krb5/config";
  };

  home.packages = [
    pkgs.freerdp
    pkgs.krb5
    pkgs.winbox
  ];

  wayland.windowManager.hyprland.settings.bind =
    lib.mkIf osConfig.cfg.userConfig.desktop.hyprland.enable
      [
        {
          _args = [
            (lib.generators.mkLuaInline ''mainmod .. " + g"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${rdp}/bin/rdp")'')
          ];
        }
      ];

  accounts.email.accounts."gewis m-account" = {
    address = "m10878@gewis.nl";
    realName = "Luuk Blankenstijn";
    userName = "m10878@gewis.nl";

    imap = {
      host = "imap.gewis.nl";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.gewis.nl";
      port = 465;
      tls.enable = true;
    };

    thunderbird = {
      enable = true;
      profiles = [ "default" ];
      settings = id: {
        "mail.server.server_${id}.authMethod" = 3;
        "mail.smtpserver.smtp_${id}.authMethod" = 3;
      };
    };
  };
}
