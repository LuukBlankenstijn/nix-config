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
      displayManager = {
        enable = mkEnableOption "display manager (noctalia-greeter)";
        defaultSession = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "Hyprland";
          description = "Session pre-selected in the greeter's picker. This is the picker label, not the desktop file id — list them with `noctalia-greeter sessions` (`Hyprland`, `Niri`). Null lets the greeter remember the last pick.";
        };
      };
      audio.enable = mkEnableOption "audio stack (PipeWire, ALSA, JACK, PulseAudio compat)";
      hardware.enable = mkEnableOption "desktop hardware support (firmware, GPU drivers)";
      niri.enable = mkEnableOption "niri scrolling-tiling compositor as a second session (per-user config lives under users.<name>.desktop.niri)";

      touchscreen = {
        enable = mkEnableOption "touchscreen (touch pinned to its own panel, on-screen keyboard, edge gestures)";

        device = mkOption {
          type = types.str;
          example = "ELAN901C:00 04F3:413B";
          description = ''
            evdev name of the touch panel, as printed by
            `grep Name /proc/bus/input/devices`. A udev rule matches it exactly,
            so the "... UNKNOWN" siblings that digitizers register alongside the
            real node are left alone.
          '';
        };

        output = mkOption {
          type = types.str;
          defaultText = lib.literalExpression "config.cfg.laptop.internalDisplay";
          example = "eDP-1";
          description = ''
            Connector the panel is part of. Both compositors pin touch input to
            it. Left unset they spread touch over whichever output they happen to
            pick, so the moment you dock, a tap on the laptop screen moves the
            pointer on an external monitor instead.
          '';
        };

        size = {
          width = mkOption {
            type = types.int;
            default = 1920;
            description = "Panel width in pixels. Only used to turn gestures.threshold into a distance, so it need not match the mode you actually run.";
          };

          height = mkOption {
            type = types.int;
            default = 1200;
            description = "Panel height in pixels. See size.width.";
          };
        };

        keyboard = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "wvkbd on-screen keyboard, raised by Mod+I or by swiping up from the bottom edge.";
          };

          autoShow = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Let wvkbd raise itself whenever a client asks for text input
              (zwp_input_method_v2). This is meant for phones, and on a laptop it
              overreaches: Ghostty advertises text input for the whole time it has
              focus, so the keyboard sits on screen permanently and eats
              landscapeHeight pixels of every terminal. Worth turning on only if
              you use the machine without its keyboard.
            '';
          };

          height = mkOption {
            type = types.int;
            default = 480;
            description = "Keyboard height in logical pixels while the panel is taller than it is wide.";
          };

          landscapeHeight = mkOption {
            type = types.int;
            default = 340;
            description = "Keyboard height in logical pixels in the usual landscape orientation.";
          };

          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [
              "--fn"
              "JetBrainsMono Nerd Font 14"
            ];
            description = "Extra arguments for wvkbd-mobintl.";
          };
        };

        gestures = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Edge and multi-finger gestures, via lisgd. Neither compositor can do
              this on its own: niri only reads touch inside the overview, and
              hyprgrass — the usual answer on Hyprland — does not build against
              the pinned 0.56. lisgd reads the panel's evdev node directly, which
              is what the udev rule's uaccess tag is for.
            '';
          };

          threshold = mkOption {
            type = types.float;
            default = 0.1;
            description = "Fraction of the panel's short side a finger must travel before a gesture fires.";
          };

          timeoutMs = mkOption {
            type = types.int;
            default = 700;
            description = "Time a gesture has to finish in. Slower swipes are ignored, so a drag inside an app does not trip one.";
          };

          extra = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "2,LR,*,*,R,playerctl next" ];
            description = "Extra lisgd gesture specs, appended to the defaults. The format is `fingers,direction,edge,distance,mode,command` — see lisgd(1).";
          };
        };
      };
    };

    server.enable = mkEnableOption "server-specific features (OpenSSH, wheel passwordless sudo)";

    bluetooth.enable = mkEnableOption "Bluetooth hardware (the GUI is per-user under users.<name>.desktop.bluetooth)";

    boot.splash.enable = mkEnableOption "Plymouth boot splash (Catppuccin Mocha, systemd stage 1)";

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

    laptop = {
      enable = mkEnableOption "laptop features (TLP power management, lid-switch handling)";

      battery = mkOption {
        type = types.str;
        default = "BAT0";
        description = "Battery under /sys/class/power_supply that the status bar reads. Run `ls /sys/class/power_supply` on the host to find it.";
      };

      adapter = mkOption {
        type = types.str;
        default = "AC0";
        description = "AC adapter under /sys/class/power_supply that the status bar reads. Run `ls /sys/class/power_supply` on the host to find it.";
      };

      internalDisplay = mkOption {
        type = types.str;
        default = "eDP-1";
        description = "Connector name of the built-in panel. Run `hyprctl monitors` on the host to find it.";
      };
    };

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
        gpu.enable = mkEnableOption "NVIDIA GPU passthrough for k3s (driver, container toolkit, containerd nvidia runtime, gpu node label/taint)";
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
                  displays = {
                    enable = mkEnableOption "monitor layout management (shikane auto-profiles + wdisplays GUI)";
                    profiles = mkOption {
                      type = types.listOf types.attrs;
                      default = [ ];
                      example = lib.literalExpression ''
                        [
                          {
                            name = "docked";
                            output = [
                              { search = "n=eDP-1"; enable = true; mode = "2880x1800@120Hz"; position = "0,0"; scale = 2.0; }
                            ];
                          }
                        ]
                      '';
                      description = "shikane profiles for this host's monitor layouts. Generate one with `shikanectl export` while the monitors are attached.";
                    };
                  };
                  pyprland.enable = mkEnableOption "pyprland scratchpad system";
                };

                niri = {
                  enable = mkEnableOption "niri session for this user (requires desktop.niri.enable on the host)";
                  noctalia.enable = mkOption {
                    type = types.bool;
                    default = true;
                    description = "Noctalia shell inside the niri session: bar, notifications, launcher, lock screen, wallpaper and OSDs. Disable to leave niri bare.";
                  };
                  outputs = mkOption {
                    type = types.attrsOf types.attrs;
                    default = { };
                    example = lib.literalExpression ''
                      {
                        "eDP-1" = {
                          mode = { width = 2880; height = 1800; refresh = 120.0; };
                          scale = 2.0;
                        };
                      }
                    '';
                    description = "niri output configuration, keyed by connector name. Run `niri msg outputs` on the host to find the names and modes.";
                  };
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
              omp.enable = mkEnableOption "Oh my Pi (terminal coding agent)";
              pi.enable = mkEnableOption "pi (terminal coding agent)";
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

    # the touchscreen is glued to the built-in panel on every machine that has one
    cfg.desktop.touchscreen.output = mkDefault config.cfg.laptop.internalDisplay;

    cfg.desktop.niri.enable = mkIf (builtins.any (u: u.desktop.niri.enable) (
      builtins.attrValues config.cfg.users
    )) (mkDefault true);

    # winapps (any user) requires docker or podman
    cfg.virtualisation.docker.enable = mkIf (
      !config.cfg.virtualisation.podman.enable
      && (builtins.any (u: u.desktop.winapps.enable) (builtins.attrValues config.cfg.users))
    ) (mkDefault true);
  };
}
