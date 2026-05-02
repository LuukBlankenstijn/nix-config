{
  plugins.rustaceanvim = {
    enable = true;
    settings = {
      server = {
        default_settings = {
          rust-analyzer = {
            check = {
              command = "clippy";
              extraArgs = [ "--no-deps" ];
            };
            checkOnSave = true;
            diagnostics = {
              experimental.enable = false;
            };
            procMacro.enable = true;
            cargo = {
              buildScripts.enable = true;
            };
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>rr";
      action = "<cmd>RustAnalyzer restart<cr>";
      options.desc = "Restart rust-analyzer";
    }
  ];
}
