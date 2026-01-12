{ pkgs, config, ... }:
let
  rdp = pkgs.writeShellScriptBin "rdp" ''
    if ! ${pkgs.eduvpn-client}/bin/eduvpn-cli status | grep -q "Connected to: \"Eindhoven University of Technology\""; then
      ${pkgs.hyprland}/bin/hyprctl notify 2 5000 "rgb(ff1111)" "Eduvpn not connected!"
      exit 1
    fi

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
