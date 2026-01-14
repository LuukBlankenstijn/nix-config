{ lib, ... }:
{
  config = {
    lsp = {
      keymaps = [
        # --- Navigation (Snacks Picker) ---
        {
          key = "gd";
          action = lib.nixvim.mkRaw "function() Snacks.picker.lsp_definitions() end";
          options.desc = "Goto Definition";
        }
        {
          key = "gr";
          action = lib.nixvim.mkRaw "function() Snacks.picker.lsp_references() end";
          options.desc = "References";
        }
        {
          key = "gI";
          action = lib.nixvim.mkRaw "function() Snacks.picker.lsp_implementations() end";
          options.desc = "Goto Implementation";
        }
        {
          key = "gy";
          action = lib.nixvim.mkRaw "function() Snacks.picker.lsp_type_definitions() end";
          options.desc = "Goto Type Definition";
        }
        {
          key = "gD";
          action = lib.nixvim.mkRaw "function() Snacks.picker.lsp_declarations() end";
          options.desc = "Goto Declaration";
        }

        # --- Native LSP Features ---
        {
          key = "K";
          lspBufAction = "hover";
          options.desc = "Hover";
        }
        {
          key = "gK";
          lspBufAction = "signature_help";
          options.desc = "Signature Help";
        }

        # --- Refactoring (Snacks & Fzf-lua) ---
        {
          key = "<leader>cr";
          action = lib.nixvim.mkRaw "function() Snacks.rename.rename() end";
          options.desc = "Rename";
        }
        {
          key = "<leader>cR";
          action = lib.nixvim.mkRaw "function() Snacks.rename.rename_file() end";
          options.desc = "Rename File";
        }
        {
          key = "<leader>ca";
          mode = [
            "n"
            "v"
          ];
          action = lib.nixvim.mkRaw "function() require('fzf-lua').lsp_code_actions() end";
          options.desc = "Code Action";
        }
        {
          key = "<leader>cA";
          mode = "n";
          action = lib.nixvim.mkRaw "function() require('fzf-lua').lsp_code_actions({ context = { only = { 'source' }, diagnostics = {} } }) end";
          options.desc = "Source Action";
        }

        # --- Codelens ---
        {
          key = "<leader>cc";
          mode = [
            "n"
            "v"
          ];
          action = lib.nixvim.mkRaw "vim.lsp.codelens.run";
          options.desc = "Run Codelens";
        }
        {
          key = "<leader>cC";
          action = lib.nixvim.mkRaw "vim.lsp.codelens.refresh";
          options.desc = "Refresh Codelens";
        }

        # --- Snacks Words ---
        {
          key = "]]";
          action = lib.nixvim.mkRaw "function() Snacks.words.jump(vim.v.count1) end";
          options.desc = "Next Reference";
        }
        {
          key = "[[";
          action = lib.nixvim.mkRaw "function() Snacks.words.jump(-vim.v.count1) end";
          options.desc = "Prev Reference";
        }
        {
          key = "<a-n>";
          action = lib.nixvim.mkRaw "function() Snacks.words.jump(vim.v.count1, true) end";
          options.desc = "Next Reference (Cycle)";
        }
        {
          key = "<a-p>";
          action = lib.nixvim.mkRaw "function() Snacks.words.jump(-vim.v.count1, true) end";
          options.desc = "Prev Reference (Cycle)";
        }

        # --- Diagnostics (From your snippet) ---
        {
          key = "[d";
          action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=-1, float=true }) end";
          options.desc = "Prev Diagnostic";
        }
        {
          key = "]d";
          action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=1, float=true }) end";
          options.desc = "Next Diagnostic";
        }
      ];

      servers = {
        basedpyright.enable = true;
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
        ruff.enable = true;
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
        action.__raw = "function() Snacks.picker.lsp_declarations() end";
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
        mode = [
          "n"
          "v"
        ];
        key = "<leader>cc";
        action.__raw = "vim.lsp.codelens.run";
        options.desc = "Run Codelens";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ca";
        action.__raw = "function() require('fzf-lua').lsp_code_actions() end";
        options.desc = "Code Action";
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
        action.__raw = "function() vim.lsp.buf.code_action({ context = { only = { 'source' }, diagnostics = {} } }) end";
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
