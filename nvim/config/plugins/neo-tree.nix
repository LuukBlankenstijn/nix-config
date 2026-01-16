{
  plugins.neo-tree = {
    enable = true;

    settings = {
      sources = [
        "filesystem"
      ];

      commands = {
        copy_path = {
          __raw = ''
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
              vim.notify("Copied to clipboard: " .. path)
            end
          '';
        };
        system_open = {
          __raw = ''
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.ui.open(path)
            end
          '';
        };
      };

      open_files_do_not_replace_types = [
        "terminal"
        "Trouble"
        "trouble"
        "qf"
        "Outline"
      ];

      filesystem = {
        bind_to_cwd = false;
        follow_current_file.enabled = true;
        filtered_items.visible = true;
        use_libuv_file_watcher = true;
      };

      window = {
        mappings = {
          "l" = "open";
          "h" = "close_node";
          "<space>" = "none";
          "Y" = "copy_path";
          "O" = "system_open";
          "P" = {
            command = "toggle_preview";
          };
        };
      };

      default_component_configs = {
        indent = {
          padding = 0;
          with_expanders = true;
          expander_collapsed = "";
          expander_expanded = "";
          expander_highlight = "NeoTreeExpander";
        };
        git_status = {
          symbols = {
            added = "✚";
            modified = "";
            deleted = "✖";
            renamed = "󰁕";
            untracked = "";
            ignored = "";
            unstaged = "󰄱";
            staged = "";
            conflict = "";
          };
        };
      };

      event_handlers = [
        {
          event = "file_moved";
          handler.__raw = ''
            function(data)
              Snacks.rename.on_rename_file(data.source, data.destination)
            end
          '';
        }
        {
          event = "file_renamed";
          handler.__raw = ''
            function(data)
              Snacks.rename.on_rename_file(data.source, data.destination)
            end
          '';
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>fe";
      action.__raw = ''
        function()
          local root = Snacks.git.get_root() or vim.uv.cwd()
          require("neo-tree.command").execute({ toggle = true, dir = root })
        end
      '';
      options.desc = "Explorer NeoTree (Git Root)";
    }
    {
      mode = "n";
      key = "<leader>fE";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end
      '';
      options.desc = "Explorer NeoTree (cwd)";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<leader>fe";
      options = {
        desc = "Explorer NeoTree (Git Root)";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<leader>fE";
      options = {
        desc = "Explorer NeoTree (cwd)";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ge";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end
      '';
      options.desc = "Git Explorer";
    }
    {
      mode = "n";
      key = "<leader>be";
      action.__raw = ''
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end
      '';
      options.desc = "Buffer Explorer";
    }
  ];

  autoCmd = [
    {
      event = "BufEnter";
      desc = "Start Neo-tree with directory";
      once = true;
      callback = {
        __raw = ''
          function()
            if package.loaded["neo-tree"] then return end
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        '';
      };
    }
    {
      event = "TermClose";
      pattern = "*lazygit";
      callback = {
        __raw = ''
          function()
            if package.loaded["neo-tree.sources.git_status"] then
              require("neo-tree.sources.git_status").refresh()
            end
          end
        '';
      };
    }
  ];
}
