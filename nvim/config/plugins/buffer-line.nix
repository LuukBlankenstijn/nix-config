{
  config = {
    plugins.bufferline = {
      enable = true;
      settings = {
        options = {
          close_command.__raw = "function(n) Snacks.bufdelete(n) end";
          right_mouse_command.__raw = "function(n) Snacks.bufdelete(n) end";

          diagnostics = "nvim_lsp";
          always_show_bufferline = false;

          diagnostics_indicator = ''
            function(_, _, diag)
              local icons = { Error = " ", Warn = " ", Hint = " ", Info = " " }
              local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                .. (diag.warning and icons.Warn .. diag.warning or "")
              return vim.trim(ret)
            end
          '';

          offsets = [
            { filetype = "snacks_layout_box"; }
          ];
        };
      };
    };

    # required dependency
    plugins.mini-icons = {
      enable = true;
      mockDevIcons = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>bp";
        action = "<Cmd>BufferLineTogglePin<CR>";
        options.desc = "Toggle Pin";
      }
      {
        mode = "n";
        key = "<leader>bP";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options.desc = "Delete Non-Pinned Buffers";
      }
      {
        mode = "n";
        key = "<leader>br";
        action = "<Cmd>BufferLineCloseRight<CR>";
        options.desc = "Delete Buffers to the Right";
      }
      {
        mode = "n";
        key = "<leader>bl";
        action = "<Cmd>BufferLineCloseLeft<CR>";
        options.desc = "Delete Buffers to the Left";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "[b";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "]b";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "[B";
        action = "<cmd>BufferLineMovePrev<cr>";
        options.desc = "Move buffer prev";
      }
      {
        mode = "n";
        key = "]B";
        action = "<cmd>BufferLineMoveNext<cr>";
        options.desc = "Move buffer next";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action.__raw = "function() Snacks.bufdelete() end";
        options = {
          desc = "Delete Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bo";
        action.__raw = "function() Snacks.bufdelete.other() end";
        options.desc = "Delete Other Buffers";
      }
    ];

    autoCmd = [
      {
        event = [
          "BufAdd"
          "BufDelete"
        ];
        callback.__raw = ''
          function()
            vim.schedule(function()
              pcall(nvim_bufferline)
            end)
          end
        '';
      }
    ];
  };
}
