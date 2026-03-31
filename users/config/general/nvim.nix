{ osConfig, lib, inputs, ... }:
{
  imports = [ inputs.neovim.homeModules.default ];

  config = lib.mkIf osConfig.cfg.userConfig.neovim.enable {
    xdg.desktopEntries.nvim = {
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
