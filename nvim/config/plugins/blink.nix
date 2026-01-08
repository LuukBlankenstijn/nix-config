{
  config.plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";

          "<CR>" = [
            "accept"
            "fallback"
          ];

          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];

          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
        };
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
      };
    };

    blink-compat = {
      enable = true;
      settings = {
        impersonate_nvim_cmp = true;
      };
    };

    luasnip.enable = true;

    friendly-snippets.enable = true;
  };
}
