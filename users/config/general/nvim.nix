{ osConfig, lib, pkgs, inputs, ... }:
let
  enable = osConfig.cfg.userConfig.neovim.enable;
in
{
  imports = [ inputs.neovim.homeModules.default ];

  programs.nixvim.enable = enable;

  home.packages = lib.mkIf enable [ pkgs.intelephense ];

  xdg.desktopEntries = lib.mkIf enable {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      terminal = true;
      categories = [ "Utility" "TextEditor" ];
      mimeType = [ "text/plain" ];
      icon = "nvim";
    };
  };
}
