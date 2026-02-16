{ pkgs, ... }:
{

  config = {
    extraPackages = with pkgs; [
      prettierd
      gofumpt
      goimports-reviser
      golines
      nixpkgs-fmt
      sql-formatter
      buf
    ];

    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "first" }
          end
        '';
        default_format_opts = {
          timeout_ms = 3000;
          async = false;
          quiet = false;
          lsp_format = "first";
        };

        formatters_by_ft = {
          nix = [ "nixpkgs-fmt" ];
          go = [
            "gofumpt"
            "goimports-reviser"
            "golines"
          ];
          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          javascriptreact = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
          html = [ "prettierd" ];
          json = [ "prettierd" ];
          markdown = [ "prettierd" ];
          dockerfile = [ "prettierd" ];
          proto = [ "buf" ];
          sql = [ "sql-formatter" ];
          mysql = [ "sql-formatter" ];
        };

        formatters.injected.options.ignore_errors = true;
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cF";
        action.__raw = ''
          function()
            require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
          end
        '';
        options = {
          silent = true;
          desc = "Format Injected Langs";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>cf";
        action.__raw = ''
          function()
            require("conform").format({ bufnr = 0 })
          end
        '';
        options = {
          silent = true;
          desc = "Format Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>uf";
        action.__raw = ''
          function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            print("Autoformat (Global) " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
          end
        '';
        options = {
          silent = true;
          desc = "Toggle Autoformat (Global)";
        };
      }
      {
        mode = "n";
        key = "<leader>uF";
        action.__raw = ''
          function()
            vim.b.disable_autoformat = not vim.b.disable_autoformat
            print("Autoformat (Buffer) " .. (vim.b.disable_autoformat and "disabled" or "enabled"))
          end
        '';
        options = {
          silent = true;
          desc = "Toggle Autoformat (Buffer)";
        };
      }
    ];
  };
}
