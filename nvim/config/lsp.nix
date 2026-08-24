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
          action = lib.nixvim.mkRaw "vim.lsp.buf.rename";
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
          key = "<leader>ci";
          action = lib.nixvim.mkRaw "function() vim.cmd('LspAddMissingImports') end";
          options.desc = "Add Missing Imports";
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
        helmls.enable = true;
        html.enable = true;
        intelephense = {
          enable = true;
          package = null;
        };
        jdtls.enable = true;
        jsonls.enable = true;
        kotlin_language_server.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        postgres_lsp.enable = true;
        pyright.enable = true;
        ruff.enable = true;
        sqls.enable = true;
        svelte.enable = true;
        tailwindcss.enable = true;
        tinymist.enable = true;
        typos_lsp.enable = true;
        vtsls.enable = true;
        yamlls.enable = true;
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

    extraConfigLua = ''
      -- Pull in missing imports through the LSP after a paste, so dropping a
      -- snippet into a file also brings whatever it references along with it.
      local M = {}

      if vim.g.auto_import_on_paste == nil then
        vim.g.auto_import_on_paste = true
      end

      -- Kinds these servers handle but leave out of their advertised list.
      local unadvertised_kinds = {
        ts_ls = { "source.addMissingImports.ts" },
        vtsls = { "source.addMissingImports.ts" },
      }

      -- The code action kinds a client is willing to run for us.
      local function import_kinds(client)
        local provider = client.server_capabilities and client.server_capabilities.codeActionProvider
        local advertised = type(provider) == "table" and provider.codeActionKinds or {}
        local add, organize = vim.deepcopy(unadvertised_kinds[client.name] or {}), {}
        for _, kind in ipairs(advertised) do
          local lowered = kind:lower()
          if lowered:find("addmissingimports", 1, true) then
            table.insert(add, kind)
          elseif lowered:find("organizeimports", 1, true) then
            table.insert(organize, kind)
          end
        end

        -- Prefer adding: on TypeScript servers organizeImports also strips the
        -- imports the pasted code has not started using yet.
        return #add > 0 and add or organize
      end

      -- Not every server honours context.only -- typos_lsp happily answers with
      -- spelling fixes -- so check what came back before touching the buffer.
      local function is_wanted(kind, kinds)
        if type(kind) ~= "string" then
          return false
        end
        for _, wanted in ipairs(kinds) do
          if kind == wanted or kind:sub(1, #wanted + 1) == wanted .. "." then
            return true
          end
        end
        return false
      end

      -- A server that has not caught up with the paste yet answers with the
      -- action but no edit in it, which must not count as a fix.
      local function has_edit(edit)
        if type(edit) ~= "table" then
          return false
        end
        return (edit.changes and next(edit.changes) ~= nil)
          or (edit.documentChanges and next(edit.documentChanges) ~= nil)
      end

      local apply_action
      apply_action = function(client, action, bufnr, on_applied)
        if has_edit(action.edit) or action.command then
          if has_edit(action.edit) then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
          if action.command then
            local command = type(action.command) == "table" and action.command or action
            client:exec_cmd(command, { bufnr = bufnr })
          end
          if on_applied then
            on_applied()
          end
        elseif client:supports_method("codeAction/resolve") then
          client:request("codeAction/resolve", action, function(err, resolved)
            if not err and resolved then
              apply_action(client, resolved, bufnr, on_applied)
            end
          end, bufnr)
        end
      end

      --- Run the import-adding code actions of every attached client.
      --- @param bufnr integer|nil buffer to fix, 0 or nil for the current one
      --- @param on_applied function|nil called once an action has been applied
      function M.add_missing_imports(bufnr, on_applied)
        bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
        if not vim.api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].modifiable then
          return
        end

        local last_line = math.max(vim.api.nvim_buf_line_count(bufnr) - 1, 0)
        local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })

        for _, client in ipairs(clients) do
          local kinds = import_kinds(client)
          if #kinds > 0 then
            client:request("textDocument/codeAction", {
              textDocument = vim.lsp.util.make_text_document_params(bufnr),
              range = {
                start = { line = 0, character = 0 },
                ["end"] = { line = last_line, character = 0 },
              },
              context = {
                diagnostics = {},
                only = kinds,
                triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
              },
            }, function(err, result)
              if err or not result then
                return
              end
              for _, action in ipairs(result) do
                if is_wanted(action.kind, kinds) then
                  apply_action(client, action, bufnr, on_applied)
                end
              end
            end, bufnr)
          end
        end
      end

      -- A server can only name the missing imports once it has caught up with
      -- the pasted text, and how long that takes depends on the project. Ask a
      -- few times over the next second and stop as soon as something lands.
      local retry_delays = { 250, 450, 750 }
      local scheduled = {}

      local function attempt(bufnr, index)
        if not scheduled[bufnr] then
          return
        end
        M.add_missing_imports(bufnr, function()
          scheduled[bufnr] = nil
        end)
        local delay = retry_delays[index + 1]
        if delay then
          vim.defer_fn(function()
            attempt(bufnr, index + 1)
          end, delay)
        else
          scheduled[bufnr] = nil
        end
      end

      local function schedule(bufnr)
        if not vim.g.auto_import_on_paste then
          return
        end
        bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
        if scheduled[bufnr] then
          return
        end
        scheduled[bufnr] = true
        vim.defer_fn(function()
          attempt(bufnr, 1)
        end, retry_delays[1])
      end

      -- Bracketed paste from the terminal, which also covers insert mode.
      local paste = vim.paste
      vim.paste = function(lines, phase)
        local ok = paste(lines, phase)
        if phase == -1 or phase == 3 then
          schedule(0)
        end
        return ok
      end

      -- <expr> keeps counts, registers and dot-repeat intact.
      for _, key in ipairs({ "p", "P", "gp", "gP" }) do
        vim.keymap.set({ "n", "x" }, key, function()
          schedule(0)
          return key
        end, { expr = true, desc = "Paste (add missing imports)" })
      end

      vim.api.nvim_create_user_command("LspAddMissingImports", function()
        M.add_missing_imports(0)
      end, { desc = "Add missing imports via LSP" })
    '';
  };
}
