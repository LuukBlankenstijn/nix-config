{
  config = {
    plugins.trouble = {
      enable = true;
      settings.modes.lsp.win.position = "right";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options = {
          silent = true;
          desc = "Diagnostics: Toggle Workspace List (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options = {
          silent = true;
          desc = "Diagnostics: Toggle Buffer List (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>cs";
        action = "<cmd>Trouble symbols toggle<cr>";
        options = {
          silent = true;
          desc = "Symbols: Toggle Outline (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>cS";
        action = "<cmd>Trouble lsp toggle<cr>";
        options = {
          silent = true;
          desc = "LSP: Toggle References/Definitions (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options = {
          silent = true;
          desc = "Location List: Toggle (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options = {
          silent = true;
          desc = "Quickfix List: Toggle (Trouble)";
        };
      }
      {
        mode = "n";
        key = "[q";
        action.__raw = ''
          function()
            if require("trouble").is_open() then
              require("trouble").prev({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
        options = {
          silent = true;
          desc = "Previous: Trouble/Quickfix Item";
        };
      }
      {
        mode = "n";
        key = "]q";
        action.__raw = ''
          function()
            if require("trouble").is_open() then
              require("trouble").next({ skip_groups = true, jump = true })
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end
        '';
        options = {
          silent = true;
          desc = "Next: Trouble/Quickfix Item";
        };
      }
      {
        mode = "n";
        key = "]e";
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
          end
        '';
        options = {
          silent = true;
          desc = "Next: Error Diagnostic";
        };
      }
      {
        mode = "n";
        key = "[e";
        action.__raw = ''
          function()
            vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
          end
        '';
        options = {
          silent = true;
          desc = "Previous: Error Diagnostic";
        };
      }
    ];
  };
}
