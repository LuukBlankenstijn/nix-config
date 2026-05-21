{ pkgs, ... }:
{
  config = {
    extraPackages = with pkgs; [
      ripgrep
      fd
      cliphist
    ];

    plugins.snacks.settings = {
      styles = {
        input = {
          border = "rounded";
        };
      };

      picker = {
        enabled = true;
        ui_select = true;
        prompt = "  ";
        layout = {
          preset = "telescope";
        };
        formatters = {
          file = {
            filename_first = true;
          };
        };
        win = {
          input = {
            keys = {
              "<c-x>" = false;
              "<c-q>" = {
                __unkeyed-1 = "select_all";
                __unkeyed-2 = "list";
                mode = [
                  "n"
                  "i"
                ];
              };
              "<c-u>" = {
                __unkeyed-1 = "preview_scroll_up";
                mode = [
                  "n"
                  "i"
                ];
              };
              "<c-d>" = {
                __unkeyed-1 = "preview_scroll_down";
                mode = [
                  "n"
                  "i"
                ];
              };
            };
          };
        };
        sources = {
          buffers = {
            win = {
              input = {
                keys = {
                  "<c-x>" = false;
                  "<a-d>" = {
                    __unkeyed-1 = "bufdelete";
                    mode = [
                      "n"
                      "i"
                    ];
                  };
                };
              };
            };
          };
        };
      };

      explorer = {
        enabled = true;
        replace_netrw = true;
      };
    };

    keymaps = [
      # --- File & Buffer Search ---
      {
        mode = "n";
        key = "<leader>,";
        action.__raw = ''
          function() Snacks.picker.buffers({ sort_mru = true, sort_lastused = true }) end
        '';
        options = {
          silent = true;
          desc = "Switch Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader><space>";
        action.__raw = "function() Snacks.picker.files() end";
        options = {
          silent = true;
          desc = "Find Files (Root)";
        };
      }
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = "function() Snacks.picker.grep() end";
        options = {
          silent = true;
          desc = "Grep (Root)";
        };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "function() Snacks.picker.files() end";
        options = {
          silent = true;
          desc = "Find Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action.__raw = "function() Snacks.picker.recent() end";
        options = {
          silent = true;
          desc = "Recent Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action.__raw = "function() Snacks.picker.git_files() end";
        options = {
          silent = true;
          desc = "Git Files";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>sH";
        action.__raw = "function() Snacks.picker.cliphist() end";
        options = {
          silent = true;
          desc = "Clipboard History";
        };
      }

      # --- Search / UI Helpers ---
      {
        mode = "n";
        key = ''<leader>s"'';
        action.__raw = "function() Snacks.picker.registers() end";
        options = {
          silent = true;
          desc = "Registers";
        };
      }
      {
        mode = "n";
        key = "<leader>sa";
        action.__raw = "function() Snacks.picker.autocmds() end";
        options = {
          silent = true;
          desc = "Auto Commands";
        };
      }
      {
        mode = "n";
        key = "<leader>sb";
        action.__raw = "function() Snacks.picker.lines() end";
        options = {
          silent = true;
          desc = "Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>sc";
        action.__raw = "function() Snacks.picker.command_history() end";
        options = {
          silent = true;
          desc = "Command History";
        };
      }
      {
        mode = "n";
        key = "<leader>sC";
        action.__raw = "function() Snacks.picker.commands() end";
        options = {
          silent = true;
          desc = "Commands";
        };
      }
      {
        mode = "n";
        key = "<leader>sj";
        action.__raw = "function() Snacks.picker.jumps() end";
        options = {
          silent = true;
          desc = "Jumplist";
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action.__raw = "function() Snacks.picker.loclist() end";
        options = {
          silent = true;
          desc = "Location List";
        };
      }
      {
        mode = "n";
        key = "<leader>sq";
        action.__raw = "function() Snacks.picker.qflist() end";
        options = {
          silent = true;
          desc = "Quickfix List";
        };
      }
      {
        mode = "n";
        key = "<leader>sR";
        action.__raw = "function() Snacks.picker.resume() end";
        options = {
          silent = true;
          desc = "Resume";
        };
      }

      # --- Git & LSP ---
      {
        mode = "n";
        key = "<leader>gs";
        action.__raw = "function() Snacks.picker.git_status() end";
        options = {
          silent = true;
          desc = "Git Status";
        };
      }
      {
        mode = "n";
        key = "<leader>gc";
        action.__raw = "function() Snacks.picker.git_log() end";
        options = {
          silent = true;
          desc = "Git Commits";
        };
      }
      {
        mode = "n";
        key = "<leader>sd";
        action.__raw = "function() Snacks.picker.diagnostics_buffer() end";
        options = {
          silent = true;
          desc = "Document Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sD";
        action.__raw = "function() Snacks.picker.diagnostics() end";
        options = {
          silent = true;
          desc = "Workspace Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sk";
        action.__raw = "function() Snacks.picker.keymaps() end";
        options = {
          silent = true;
          desc = "Key Maps";
        };
      }
      {
        mode = "n";
        key = "<leader>sh";
        action.__raw = "function() Snacks.picker.help() end";
        options = {
          silent = true;
          desc = "Help Pages";
        };
      }
      {
        mode = "n";
        key = "<leader>sw";
        action.__raw = "function() Snacks.picker.grep_word() end";
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
            Snacks.picker.lsp_symbols({
              filter = {
                default = { "Function", "Class", "Method", "Interface", "Struct", "Trait" },
              },
              layout = { preview = "main" },
            })
          end
        '';
        options = {
          silent = true;
          desc = "Goto Symbol (Document)";
        };
      }

      # --- Explorer (Snacks) ---
      {
        mode = "n";
        key = "<leader>fE";
        action.__raw = ''
          function()
            local root = Snacks.git.get_root() or vim.uv.cwd()
            Snacks.explorer({ cwd = root })
          end
        '';
        options.desc = "Explorer (Git Root)";
      }
      {
        mode = "n";
        key = "<leader>fe";
        action.__raw = ''
          function()
            Snacks.explorer({ cwd = vim.uv.cwd() })
          end
        '';
        options.desc = "Explorer (cwd)";
      }
      {
        mode = "n";
        key = "<leader>E";
        action = "<leader>fE";
        options = {
          desc = "Explorer (Git Root)";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<leader>fe";
        options = {
          desc = "Explorer (cwd)";
          remap = true;
        };
      }
    ];
  };
}
