{ pkgs, ... }:
{
  config = {
    extraPackages = with pkgs; [
      imagemagick
      ghostscript
    ];

    plugins.snacks = {
      enable = true;
      settings = {
        image = {
          enabled = true;
          doc = {
            inline = true;
            float = true;
            max_width = 80;
          };
        };
      };
    };
  };
}
