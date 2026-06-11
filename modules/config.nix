{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkDefault
    mkIf
    types
    ;
in
{
  options.cfg = {

    # ── infrastructure ──────────────────────────────────────────────────────────
    impermanence = {
      enable = mkEnableOption "ZFS impermanence (ephemeral root, /persist)";
      rollback.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Roll back ZFS root to blank snapshot on every boot. Disable to set up a new system before committing to ephemeral state.";
      };
    };

    gpg.enable = mkEnableOption "gpg key agent";

    secrets.file = mkOption {
      type = types.path;
      default = ../secrets/secrets.yaml;
      description = "Path to the sops secrets file used by both NixOS and home-manager.";
    };

    # ── system features ─────────────────────────────────────────────────────────
    desktop = {
      enable = mkEnableOption "desktop environment (Hyprland, portals, etc.)";
      displayManager.enable = mkEnableOption "display manager (ReGreet)";
      audio.enable = mkEnableOption "audio stack (PipeWire, ALSA, JACK, PulseAudio compat)";
      hardware.enable = mkEnableOption "desktop hardware support (firmware, GPU drivers)";
    };

    server.enable = mkEnableOption "server-specific features (OpenSSH, wheel passwordless sudo)";

    bluetooth.enable = mkEnableOption "Bluetooth hardware + blueman";

    networking = {
      enable = mkEnableOption "NetworkManager";
      wifi.enable = mkEnableOption "Wi-Fi support (iwd)";
      tailscale = {
        enable = mkEnableOption "Tailscale mesh VPN";
        loginServer = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional login server for Tailscale (e.g. Headscale URL)";
        };
        ssh.enable = mkEnableOption "OpenSSH server reachable only via the tailscale0 interface";
      };
      netbird = {
        enable = mkEnableOption "Netbird mesh VPN";
        profiles = mkOption {
          type = types.attrsOf (
            types.submodule (
              { name, ... }:
              {
                options = {
                  port = mkOption {
                    type = types.port;
                    default = 51820;
                    description = "WireGuard port this profile listens on. Must be unique across profiles on the same host.";
                  };
                  managementUrl = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Optional management server URL (sets NB_MANAGEMENT_URL).";
                  };
                  ssh = {
                    enable = mkEnableOption "OpenSSH server reachable via this profile's nb-${name} interface";
                    netbirdSsh = mkEnableOption "Netbird's built-in SSH server (JWT/SSO login, usable from the web dashboard). Runs this client unhardened/as root so it can switch into the login user";
                  };
                  setupKey = {
                    enable = mkEnableOption "Netbird setup key (sops secret managed by this module)";
                    secretName = mkOption {
                      type = types.str;
                      default = if name == "netbird" then "netbird-setupkey" else "netbird-setupkey-${name}";
                      defaultText = lib.literalExpression "\"netbird-setupkey\" (\"netbird-setupkey-\${profileName}\" for non-default profiles)";
                      description = "Name of the sops secret holding the setup key. The module declares this secret and restarts the login unit when it changes.";
                    };
                  };
                };
              }
            )
          );
          default = { };
          description = "Netbird profiles. Each entry becomes a separate `services.netbird.clients.<name>` entry — i.e. a separate netbird daemon, interface (`nb-<name>`), and state file.";
        };
      };
      nftables.enable = mkEnableOption "nftables backend (instead of iptables)";
    };

    laptop.enable = mkEnableOption "laptop features (TLP power management, lid-switch handling)";

    virtualisation = {
      docker.enable = mkEnableOption "Docker container runtime";
      podman = {
        enable = mkEnableOption "Podman container runtime";
        dockerAlias = mkEnableOption "alias podman to docker";
      };
      libvirtd.enable = mkEnableOption "libvirtd (KVM/QEMU hypervisor)";
      virtManager.enable = mkEnableOption "virt-manager GUI (implies libvirtd)";
    };

    services = {
      headscale.enable = mkEnableOption "Headscale – self-hosted Tailscale control server";
      traefik.enable = mkEnableOption "Traefik – reverse proxy and edge router";
      k3s = {
        enable = mkEnableOption "K3s – lightweight Kubernetes distribution";
        clusterInit = mkEnableOption "initialize a new cluster with embedded etcd";
      };
    };

    # ── identity ────────────────────────────────────────────────────────────────
    user = mkOption {
      type = types.str;
      description = "Primary username for this machine";
    };

    # ── per-user config ─────────────────────────────────────────────────────────
    users = mkOption {
      default = { };
      description = "Per-user configuration, keyed by username";
      type = types.attrsOf (
        types.submodule (
          { config, ... }:
          {
            options = {

              # ── desktop ────────────────────────────────────────────────────────
              desktop = {
                enable = mkEnableOption "desktop environment (GUI apps, XDG, theming)";

                wallpaper = mkOption {
                  type = types.path;
                  default = ../assets/wallpapers/nature.jpg;
                  description = "Wallpaper used by the display manager, hyprpaper, and (by default) hyprlock.";
                };

                hyprland = {
                  enable = mkEnableOption "Hyprland window manager";
                  idle.enable = mkEnableOption "hypridle (auto screen dim / lock / suspend)";
                  lock = {
                    enable = mkEnableOption "hyprlock (lock screen)";
                    wallpaper = mkOption {
                      type = types.path;
                      default = config.desktop.wallpaper;
                      defaultText = lib.literalExpression "config.desktop.wallpaper";
                      description = "Wallpaper for the lock screen. Defaults to desktop.wallpaper.";
                    };
                  };
                  paper.enable = mkEnableOption "hyprpaper (wallpaper daemon)";
                  shell.enable = mkEnableOption "hyprshell (window overview / switcher)";
                  picker.enable = mkEnableOption "hyprpicker (screen colour picker)";
                  mon.enable = mkEnableOption "hyprmon (monitor profile manager)";
                  pyprland.enable = mkEnableOption "pyprland scratchpad system";
                };

                cursor.enable = mkEnableOption "cursor theme (Adwaita)";
                nautilus.enable = mkEnableOption "Nautilus file manager";
                styling.enable = mkEnableOption "GTK/Qt dark theming (Adwaita)";
                waybar.enable = mkEnableOption "Waybar status bar";
                keyring.enable = mkEnableOption "Seahorse keyring GUI";
                notifications.enable = mkEnableOption "swaync notification daemon (and waybar widget)";

                terminal.enable = mkEnableOption "Ghostty terminal emulator";
                browser = {
                  enable = mkEnableOption "Zen browser";
                  containers = mkOption {
                    type = types.attrsOf (
                      types.submodule {
                        options = {
                          color = mkOption {
                            type = types.str;
                            description = "Container colour (e.g. red, blue, green).";
                          };
                          icon = mkOption {
                            type = types.str;
                            default = "fingerprint";
                            description = "Container icon.";
                          };
                          id = mkOption {
                            type = types.int;
                            description = "Container numeric id (must be unique within the profile).";
                          };
                        };
                      }
                    );
                    default = { };
                    description = "Zen browser containers for the default profile.";
                  };
                  extensions = mkOption {
                    type = types.listOf types.str;
                    default = [ ];
                    description = "Firefox addon attribute names (from nur firefox-addons) to install.";
                  };
                };
                email.enable = mkEnableOption "email clients (Thunderbird, ProtonMail Bridge)";
                tailscale.enable = mkEnableOption "Tailscale system-tray applet";
                bluetooth.enable = mkEnableOption "Bluetooth GUI (Overskride, waybar widget)";

                winapps.enable = mkEnableOption "WinApps – Windows applications via Docker/RDP";
              };

              # ── general tools ──────────────────────────────────────────────────
              git = {
                enable = mkEnableOption "git configuration";
                extraSettings = mkOption {
                  type = types.attrs;
                  default = { };
                  description = "Extra git settings, deep-merged into programs.git.settings (later wins on conflicts).";
                };
                dirSettings = mkOption {
                  type = types.attrsOf types.attrs;
                  default = { };
                  example = {
                    "gitdir:~/code/" = {
                      user.email = "me@work.example";
                    };
                  };
                  description = ''
                    Per-directory git settings. Each attribute name is a git
                    `includeIf` condition (e.g. `gitdir:~/code/`) and the value
                    is an attrset of settings that will only apply when that
                    condition matches.
                  '';
                };
              };
              neovim.enable = mkEnableOption "Neovim editor";
              rbw.enable = mkEnableOption "rbw Bitwarden CLI";
              shell.enable = mkEnableOption "zsh shell configuration";
              clipboard = {
                enable = mkEnableOption "clipboard tools (wl-clipboard, xclip, osc52)";
                history.enable = mkEnableOption "clipboard history (cliphist)";
              };

              # ── extra packages ─────────────────────────────────────────────────
              extraPackages = mkOption {
                type = types.listOf types.package;
                default = [ ];
                description = "Extra packages to install for this user";
              };

              extraGroups = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Extra groups to add this user to, in addition to the defaults.";
              };

              gewis.enable = mkEnableOption "GEWIS organisation configuration";
            };
          }
        )
      );
    };

    # ── convenience ─────────────────────────────────────────────────────────────
    userConfig = mkOption {
      readOnly = true;
      description = "Shorthand for config.cfg.users.<config.cfg.user>";
      default = config.cfg.users.${config.cfg.user} or { };
    };
  };

  # ── dependency wiring ───────────────────────────────────────────────────────
  config = {
    # virt-manager requires libvirtd
    cfg.virtualisation.libvirtd.enable = mkIf config.cfg.virtualisation.virtManager.enable (
      mkDefault true
    );

    # winapps (any user) requires docker or podman
    cfg.virtualisation.docker.enable = mkIf (
      !config.cfg.virtualisation.podman.enable
      && (builtins.any (u: u.desktop.winapps.enable) (builtins.attrValues config.cfg.users))
    ) (mkDefault true);
  };
}
