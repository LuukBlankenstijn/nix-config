{
  config.colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
      transparent = false;
      terminal_colors = true;
      styles = {
        comments = { italic = true; };
        keywords = { italic = true; };
        functions = { bold = true; };
        variables = { bold = false; };
      };
      sidebars = [ "qf" "help" ];
      lualine_bold = true;
    };
  };
}
