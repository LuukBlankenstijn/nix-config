{ pkgs, config, ... }:
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
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "$mainmod, g, exec, ${rdp}/bin/rdp"
  ];
}
