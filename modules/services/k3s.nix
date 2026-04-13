{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.cfg.services.k3s.enable {
    services.k3s = {
      enable = true;
      role = "server";
      inherit (config.cfg.services.k3s) clusterInit;

      extraFlags = [
        "--write-kubeconfig-mode=0644"
        "--etcd-expose-metrics=true"
      ];
    };

    networking.firewall = {
      allowedTCPPorts = [
        6443 # k3s API
        10250 # kubelet
        2379 # etcd client
        2380 # etcd peer
        10257 # kube-controller-manager
        10259 # kube-scheduler
      ];
      allowedUDPPorts = [
        8472 # flannel VXLAN
        51820 # flannel Wireguard
      ];
    };
    boot = {

      kernelModules = [ "br_netfilter" ];
      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
        "net.bridge.bridge-nf-call-iptables" = 1;
        "net.bridge.bridge-nf-call-ip6tables" = 1;
      };
    };
    environment = {
      systemPackages = with pkgs; [
        k9s
        kubeseal
        fluxcd
      ];

      sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

      persistence."/persist" = lib.mkIf config.cfg.impermanence.enable {
        directories = [
          "/var/lib/rancher/k3s"
          "/etc/rancher/k3s"
        ];
      };
    };
  };
}
