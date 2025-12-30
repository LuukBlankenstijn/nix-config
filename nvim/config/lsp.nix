{
  config = {
    lsp = {
      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gr";
          lspBufAction = "references";
        }
        {
          key = "gI";
          lspBufAction = "implementation";
        }
        {
          key = "gy";
          lspBufAction = "type_definition";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        {
          key = "gK";
          lspBufAction = "signature_help";
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
          mode = [ "n" "v" ];
        }
        {
          key = "<leader>cr";
          lspBufAction = "rename";
        }

        {
          key = "<leader>cl";
          action.__raw = "function() Snacks.picker.lsp_config() end";
        }
        {
          key = "]]";
          action.__raw = "function() Snacks.words.jump(vim.v.count1) end";
        }
        {
          key = "[[";
          action.__raw = "function() Snacks.words.jump(-vim.v.count1) end";
        }

        {
          key = "]d";
          action.__raw =
            "function() vim.diagnostic.jump({ count = 1, float = true }) end";
        }
        {
          key = "[d";
          action.__raw =
            "function() vim.diagnostic.jump({ count = -1, float = true }) end";
        }
      ];

      servers = {
        buf_ls.enable = true;
        clangd.enable = true;
        docker_compose_language_server.enable = true;
        docker_language_server.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        postgres_lsp.enable = true;
        protols.enable = true;
        sqls.enable = true;
        tailwindcss.enable = true;
        vtsls.enable = true;
      };

      inlayHints.enable = true;
    };

    diagnostic = {
      settings = {
        underline = true;
        update_in_insert = false;
        severity_sort = true;
        virtual_text = {
          spacing = 4;
          source = "if_many";
          prefix = "●";
        };
        signs = {
          text = {
            __raw = ''
              {
                [vim.diagnostic.severity.ERROR] = "✘",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "󰌵",
                [vim.diagnostic.severity.INFO] = "",
              }
            '';
          };
        };
      };
    };

    keymaps = [
      # --- LSP Management ---
      {
        mode = "n";
        key = "<leader>cl";
        action.__raw = "function() Snacks.picker.lsp_config() end";
        options.desc = "Lsp Info";
      }
      {
        mode = "n";
        key = "gD";
        action.__raw = "vim.lsp.buf.declaration";
        options.desc = "Goto Declaration";
      }
      {
        mode = "n";
        key = "gK";
        action.__raw = "vim.lsp.buf.signature_help";
        options.desc = "Signature Help";
      }
      {
        mode = "i";
        key = "<c-k>";
        action.__raw = "vim.lsp.buf.signature_help";
        options.desc = "Signature Help";
      }

      # --- Codelens ---
      {
        mode = [ "n" "v" ];
        key = "<leader>cc";
        action.__raw = "vim.lsp.codelens.run";
        options.desc = "Run Codelens";
      }
      {
        mode = "n";
        key = "<leader>cC";
        action.__raw = "vim.lsp.codelens.refresh";
        options.desc = "Refresh & Display Codelens";
      }

      # --- Refactoring & Renaming ---
      {
        mode = "n";
        key = "<leader>cR";
        action.__raw = "function() Snacks.rename.rename_file() end";
        options.desc = "Rename File";
      }
      {
        mode = "n";
        key = "<leader>cA";
        action.__raw =
          "function() vim.lsp.buf.code_action({ context = { only = { 'source' }, diagnostics = {} } }) end";
        options.desc = "Source Action";
      }

      # --- Snacks Words (LSP Reference Navigation) ---
      {
        mode = "n";
        key = "]]";
        action.__raw = "function() Snacks.words.jump(vim.v.count1) end";
        options.desc = "Next Reference";
      }
      {
        mode = "n";
        key = "[[";
        action.__raw = "function() Snacks.words.jump(-vim.v.count1) end";
        options.desc = "Prev Reference";
      }
      {
        mode = "n";
        key = "<a-n>";
        action.__raw = "function() Snacks.words.jump(vim.v.count1, true) end";
        options.desc = "Next Reference (Cycle)";
      }
      {
        mode = "n";
        key = "<a-p>";
        action.__raw = "function() Snacks.words.jump(-vim.v.count1, true) end";
        options.desc = "Prev Reference (Cycle)";
      }
    ];
  };
}
