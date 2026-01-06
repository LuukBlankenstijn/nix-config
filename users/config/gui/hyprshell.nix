{ inputs, pkgs, ... }: {
  imports = [ inputs.hyprshell.homeModules.hyprshell ];
  programs.hyprshell = {
    enable = true;
    package = pkgs.hyprshell;
    systemd.enable = true;
    systemd.args = "-v";
    settings = {
      windows = {
        enable = true;
        items_per_row = 3;
        overview = {
          enable = true;
          key = "alt_r";
          modifier = "super";
          launcher = { max_items = 6; };
        };
        switch.enable = true;
      };
    };
  };
}
