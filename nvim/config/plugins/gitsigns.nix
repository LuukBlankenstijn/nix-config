{
  config = {
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
          untracked = { text = "▎"; };
        };
        signs_staged = {
          add = { text = "▎"; };
          change = { text = "▎"; };
          delete = { text = ""; };
          topdelete = { text = ""; };
          changedelete = { text = "▎"; };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "]h";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              require("gitsigns").nav_hunk("next")
            end
          end
        '';
        options.desc = "Next Hunk";
      }
      {
        mode = "n";
        key = "[h";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              require("gitsigns").nav_hunk("prev")
            end
          end
        '';
        options.desc = "Prev Hunk";
      }
      {
        mode = "n";
        key = "]H";
        action.__raw = ''function() require("gitsigns").nav_hunk("last") end'';
        options.desc = "Last Hunk";
      }
      {
        mode = "n";
        key = "[H";
        action.__raw = ''function() require("gitsigns").nav_hunk("first") end'';
        options.desc = "First Hunk";
      }

      {
        mode = [ "n" "v" ];
        key = "<leader>ghs";
        action = ":Gitsigns stage_hunk<CR>";
        options.desc = "Git: Stage Hunk";
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>ghr";
        action = ":Gitsigns reset_hunk<CR>";
        options.desc = "Git: Reset Hunk";
      }
      {
        mode = "n";
        key = "<leader>ghS";
        action.__raw = ''require("gitsigns").stage_buffer'';
        options.desc = "Git: Stage Buffer";
      }
      {
        mode = "n";
        key = "<leader>ghu";
        action.__raw = ''require("gitsigns").undo_stage_hunk'';
        options.desc = "Git: Undo Stage Hunk";
      }
      {
        mode = "n";
        key = "<leader>ghR";
        action.__raw = ''require("gitsigns").reset_buffer'';
        options.desc = "Git: Reset Buffer";
      }
      {
        mode = "n";
        key = "<leader>ghp";
        action.__raw = ''require("gitsigns").preview_hunk_inline'';
        options.desc = "Git: Preview Hunk Inline";
      }
      {
        mode = "n";
        key = "<leader>ghb";
        action.__raw =
          ''function() require("gitsigns").blame_line({ full = true }) end'';
        options.desc = "Git: Blame Line (Full)";
      }
      {
        mode = "n";
        key = "<leader>ghB";
        action.__raw = ''function() require("gitsigns").blame() end'';
        options.desc = "Git: Blame Buffer";
      }
      {
        mode = "n";
        key = "<leader>ghd";
        action.__raw = ''require("gitsigns").diffthis'';
        options.desc = "Git: Diff This";
      }
      {
        mode = "n";
        key = "<leader>ghD";
        action.__raw = ''function() require("gitsigns").diffthis("~") end'';
        options.desc = "Git: Diff This ~";
      }

      {
        mode = [ "o" "x" ];
        key = "ih";
        action = ":<C-U>Gitsigns select_hunk<CR>";
        options.desc = "GitSigns Select Hunk";
      }

      {
        mode = "n";
        key = "<leader>uG";
        action = "<cmd>Gitsigns toggle_signs<CR>";
        options.desc = "UI: Toggle Git Signs";
      }
    ];
  };
}
