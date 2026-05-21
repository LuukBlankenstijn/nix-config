{
  opts.laststatus = 3;

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        disabled_filetypes = {
          statusline = [ "dashboard" "alpha" "ministarter" "snacks_dashboard" ];
        };
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" ];

        lualine_c = [
          {
            __unkeyed-1 = "diagnostics";
            symbols = {
              error = "✘ ";
              warn = " ";
              info = " ";
              hint = "󰌵 ";
            };
          }
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
          # FIX: Completely kidded nvim, because of heavy polling
          # {
          #   __unkeyed-1.__raw = ''
          #     (function()
          #       local last_result = ""
          #       local last_tick = -1
          #
          #       return function()
          #         -- Only recalculate if the cursor moved or buffer changed
          #         local current_tick = vim.b.changedtick + vim.fn.line('.') + vim.fn.col('.')
          #         if current_tick == last_tick then
          #           return last_result
          #         end
          #
          #         local ok, trouble = pcall(require, "trouble")
          #         if not ok then return "" end
          #
          #         local symbols = trouble.statusline({
          #           mode = "symbols",
          #           groups = {},
          #           title = false,
          #           filter = { range = true },
          #           format = "{kind_icon}{symbol.name:Normal}",
          #           hl_group = "lualine_c_normal",
          #         })
          #
          #         if symbols and type(symbols.get) == "function" and symbols.has() then
          #           last_result = symbols.get()
          #         else
          #           last_result = ""
          #         end
          #
          #         last_tick = current_tick
          #         return last_result
          #       end
          #     end)()
          #   '';
          # }
        ];

        lualine_x = [
          {
            __unkeyed-1.__raw = ''
              function()
                local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                  return 'No LSP'
                end
                return "󰄭 " .. clients[1].name
              end
            '';
            color = {
              fg = "#ffffff";
              gui = "bold";
            };
          }
          {
            __unkeyed-1.__raw = ''
              function()
                local global = vim.g.disable_autoformat
                local buffer = vim.b.disable_autoformat
                if global then
                  return "󰉐 Global"
                elseif buffer then
                  return "󰉐 Buffer"
                end
                return ""
              end
            '';
            color.__raw =
              ''function() return { fg = Snacks.util.color("Error") } end'';
            cond.__raw =
              "function() return vim.g.disable_autoformat or vim.b.disable_autoformat end";
          }
          {
            __unkeyed-1.__raw = ''
              function() return require("noice").api.status.command.get() end'';
            cond.__raw = ''
              function() return package.loaded["noice"] and require("noice").api.status.command.has() end'';
            color.__raw =
              ''function() return { fg = Snacks.util.color("Statement") } end'';
          }
          {
            __unkeyed-1.__raw =
              ''function() return require("noice").api.status.mode.get() end'';
            cond.__raw = ''
              function() return package.loaded["noice"] and require("noice").api.status.mode.has() end'';
            color.__raw =
              ''function() return { fg = Snacks.util.color("Constant") } end'';
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = " ";
              modified = " ";
              removed = " ";
            };
            source.__raw = ''
              function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end
            '';
          }
        ];

        lualine_y = [
          {
            __unkeyed-1 = "progress";
            separator = " ";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1 = "location";
            padding = {
              left = 0;
              right = 1;
            };
          }
        ];

        lualine_z = [{
          __unkeyed-1.__raw = ''function() return " " .. os.date("%R") end'';
        }];
      };

      extensions = [ "lazy" ];
    };
  };

  # Hack to ensure lualine sees the object
  # when configuring normally either lualine prints table 0x........ when passed as a function, or errors when passed directly
  extraConfigLua = ''
    vim.schedule(function()
      local lualine = require("lualine")
      local opts = require("lualine").get_config()
      table.insert(opts.sections.lualine_x, 1, require("snacks").profiler.status())
      lualine.setup(opts)
    end)
  '';
}
