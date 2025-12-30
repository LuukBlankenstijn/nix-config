{ pkgs, ... }:
{
  config = {
    extraPackages = with pkgs; [
      fzf
      ripgrep
      fd
    ];

    plugins.fzf-lua = {
      enable = true;
      profile = "default";
      settings = {
        fzf_colors = true;
        fzf_opts = {
          "--no-scrollbar" = "";
        };
        defaults = {
          formatter = "path.dirname_first";
        };
        winopts = {
          width = 0.8;
          height = 0.8;
          preview = {
            scrollchars = [
              "┃"
              ""
            ];
          };
        };
        ui_select = true;
        keymap = {
          fzf = {
            "ctrl-q" = "select-all+accept";
            "ctrl-u" = "half-page-up";
            "ctrl-d" = "half-page-down";
            "ctrl-x" = "jump";
            "ctrl-f" = "preview-page-down";
            "ctrl-b" = "preview-page-up";
          };
        };
      };
    };

    keymaps = [
      # --- File & Buffer Search ---
      {
        mode = "n";
        key = "<leader>,";
        action = "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>";
        options = {
          silent = true;
          desc = "Switch Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader><space>";
        action = "<cmd>FzfLua files<cr>";
        options = {
          silent = true;
          desc = "Find Files (Root)";
        };
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>FzfLua live_grep<cr>";
        options = {
          silent = true;
          desc = "Grep (Root)";
        };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>FzfLua files<cr>";
        options = {
          silent = true;
          desc = "Find Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>FzfLua oldfiles<cr>";
        options = {
          silent = true;
          desc = "Recent Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua git_files<cr>";
        options = {
          silent = true;
          desc = "Git Files";
        };
      }

      # --- Search / UI Helpers ---
      {
        mode = "n";
        key = ''<leader>s"'';
        action = "<cmd>FzfLua registers<cr>";
        options = {
          silent = true;
          desc = "Registers";
        };
      }
      {
        mode = "n";
        key = "<leader>sa";
        action = "<cmd>FzfLua autocmds<cr>";
        options = {
          silent = true;
          desc = "Auto Commands";
        };
      }
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>FzfLua grep_curbuf<cr>";
        options = {
          silent = true;
          desc = "Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = "<cmd>FzfLua command_history<cr>";
        options = {
          silent = true;
          desc = "Command History";
        };
      }
      {
        mode = "n";
        key = "<leader>sC";
        action = "<cmd>FzfLua commands<cr>";
        options = {
          silent = true;
          desc = "Commands";
        };
      }
      {
        mode = "n";
        key = "<leader>sj";
        action = "<cmd>FzfLua jumps<cr>";
        options = {
          silent = true;
          desc = "Jumplist";
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = "<cmd>FzfLua loclist<cr>";
        options = {
          silent = true;
          desc = "Location List";
        };
      }
      {
        mode = "n";
        key = "<leader>sq";
        action = "<cmd>FzfLua quickfix<cr>";
        options = {
          silent = true;
          desc = "Quickfix List";
        };
      }
      {
        mode = "n";
        key = "<leader>sR";
        action = "<cmd>FzfLua resume<cr>";
        options = {
          silent = true;
          desc = "Resume";
        };
      }

      # --- Git & LSP ---
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>FzfLua git_status<cr>";
        options = {
          silent = true;
          desc = "Git Status";
        };
      }
      {
        mode = "n";
        key = "<leader>gc";
        action = "<cmd>FzfLua git_commits<cr>";
        options = {
          silent = true;
          desc = "Git Commits";
        };
      }
      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>FzfLua diagnostics_document<cr>";
        options = {
          silent = true;
          desc = "Document Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sD";
        action = "<cmd>FzfLua diagnostics_workspace<cr>";
        options = {
          silent = true;
          desc = "Workspace Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sk";
        action = "<cmd>FzfLua keymaps<cr>";
        options = {
          silent = true;
          desc = "Key Maps";
        };
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>FzfLua help_tags<cr>";
        options = {
          silent = true;
          desc = "Help Pages";
        };
      }
      {
        mode = "n";
        key = "<leader>sw";
        action = "<cmd>FzfLua grep_cword<cr>";
        options = {
          silent = true;
          desc = "Word (cwd)";
        };
      }
      {
        mode = "n";
        key = "<leader>ss";
        action.__raw = ''
          function()
            require("fzf-lua").lsp_document_symbols({
              kind_filter = { "Function", "Class", "Method", "Interface", "Struct", "Trait" },
              winopts = { preview = { layout = "vertical" } }
            })
          end
        '';
        options = {
          silent = true;
          desc = "Goto Symbol (Document)";
        };
      }
    ];
  };
}
