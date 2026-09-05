{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.desktop.binds = mkOption {
    default = { };
    description = ''
      Keybinds that launch a command, declared once and rendered into every
      window manager the user has enabled. Compositor-native binds (moving
      focus, resizing, workspaces) are not expressible here and live in the
      window manager's own module.
    '';
    type = types.attrsOf (
      types.submodule {
        options = {
          key = mkOption {
            type = types.str;
            example = "Q";
            description = "Key name, as understood by xkb (`Q`, `Print`, `XF86AudioMute`).";
          };

          mods = mkOption {
            type = types.listOf (
              types.enum [
                "mod"
                "shift"
                "ctrl"
                "alt"
              ]
            );
            default = [ "mod" ];
            description = "Modifiers held with the key. `mod` is the super key.";
          };

          command = mkOption {
            type = types.listOf types.str;
            example = lib.literalExpression ''[ "ghostty" ]'';
            description = "Command to run, as an argument vector. Not passed through a shell.";
          };

          whenLocked = mkOption {
            type = types.bool;
            default = false;
            description = "Keep the bind working while the screen is locked.";
          };

          repeat = mkOption {
            type = types.bool;
            default = false;
            description = "Fire repeatedly while the key is held.";
          };

          cooldownMs = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = "Minimum delay between activations. Only honoured by niri.";
          };

          sessions = mkOption {
            type = types.listOf (
              types.enum [
                "hyprland"
                "niri"
              ]
            );
            default = [
              "hyprland"
              "niri"
            ];
            description = "Sessions this bind belongs in. Narrow it when the command only exists in one of them.";
          };
        };
      }
    );
  };
}
