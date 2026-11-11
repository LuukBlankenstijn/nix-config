{
  plugins.direnv = {
    enable = true;
    settings.silent_load = 1;
  };

  autoGroups.direnv_lsp_restart.clear = true;

  autoCmd = [
    {
      event = "User";
      pattern = "DirenvLoaded";
      group = "direnv_lsp_restart";
      callback.__raw = ''
        (function()
          local lsp_path = vim.env.PATH
          return function()
            if vim.env.PATH == lsp_path then
              return
            end
            lsp_path = vim.env.PATH
            vim.cmd("lsp restart")
            if #vim.lsp.get_clients({ name = "rust-analyzer" }) > 0 then
              vim.cmd("RustAnalyzer restart")
            end
          end
        end)()
      '';
    }
  ];
}
