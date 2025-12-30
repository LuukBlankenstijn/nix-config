{
  config.keymaps = [
    # --- Save File --- #
    {
      mode = [
        "i"
        "n"
        "s"
        "x"
      ];
      key = "<C-s>";
      action = "<Cmd>w<CR><Esc>";
      options = {
        silent = true;
        desc = "Save File";
      };
    }
    # --- Tab Navigation ---
    {
      mode = "n";
      key = "<C-h>";
      action = ":tabp<CR>";
      options = {
        silent = true;
        desc = "Go to previous tab";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = ":tabn<CR>";
      options = {
        silent = true;
        desc = "Go to next tab";
      };
    }

    # --- Escape Shortcuts ---
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
      options = {
        silent = true;
        desc = "Exit insert mode with jk";
      };
    }
    {
      mode = "i";
      key = "kj";
      action = "<Esc>";
      options = {
        silent = true;
        desc = "Exit insert mode with kj";
      };
    }

    # --- Better Up/Down (Handles wrapped lines) ---
    {
      mode = [
        "n"
        "x"
      ];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
        desc = "Move down (visually on wrapped lines)";
      };
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
        desc = "Move up (visually on wrapped lines)";
      };
    }

    # --- Window Navigation ---
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        silent = true;
        desc = "Switch focus to the left window";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        silent = true;
        desc = "Switch focus to the lower window";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        silent = true;
        desc = "Switch focus to the upper window";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        silent = true;
        desc = "Switch focus to the right window";
        remap = true;
      };
    }

    # --- Window Resizing ---
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = {
        silent = true;
        desc = "Shrink window width (-2)";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = {
        silent = true;
        desc = "Grow window width (+2)";
      };
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = {
        silent = true;
        desc = "Grow window height (+2)";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = {
        silent = true;
        desc = "Shrink window height (-2)";
      };
    }

    # --- Window Management ---
    {
      mode = "n";
      key = "<leader>-";
      action = "<C-W>s";
      options = {
        silent = true;
        desc = "Split Window Below";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<C-w>v";
      options = {
        silent = true;
        desc = "Split Window Right";
        remap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>wd";
      action = "<C-W>c";
      options = {
        silent = true;
        desc = "Delete Window";
        remap = true;
      };
    }

    # --- Move Lines (Alt + j/k) ---
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>execute 'move .+' . v:count1<cr>==";
      options = {
        silent = true;
        desc = "Move current line down";
      };
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
      options = {
        silent = true;
        desc = "Move current line up";
      };
    }
    {
      mode = "i";
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = {
        silent = true;
        desc = "Move current line down (insert mode)";
      };
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = {
        silent = true;
        desc = "Move current line up (insert mode)";
      };
    }
    {
      mode = "v";
      key = "<A-j>";
      action = '':<C-u>execute "'<,'>move '>+" . v:count1<cr>gv=gv'';
      options = {
        silent = true;
        desc = "Move selected block down";
      };
    }
    {
      mode = "v";
      key = "<A-k>";
      action = '':<C-u>execute "'<,'>move '<-" . (v:count1 + 1)<cr>gv=gv'';
      options = {
        silent = true;
        desc = "Move selected block up";
      };
    }

    {
      mode = "v";
      key = "<";
      action = "<gv";
      options = {
        silent = true;
        desc = "Indent left and keep selection";
      };
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options = {
        silent = true;
        desc = "Indent right and keep selection";
      };
    }

    # --- Native Buffer Management ---
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options = {
        silent = true;
        desc = "Cycle to previous open buffer";
      };
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options = {
        silent = true;
        desc = "Cycle to next open buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bb";
      action = "<cmd>e #<cr>";
      options = {
        silent = true;
        desc = "Toggle between current and last-used buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>enew<cr>";
      options = {
        silent = true;
        desc = "Create a new empty buffer";
      };
    }

    # --- UI / Search ---
    {
      mode = "n";
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options = {
        silent = true;
        desc = "Clear search highlight and refresh screen";
      };
    }

    # --- Tabs ---
    {
      mode = "n";
      key = "<leader><tab>l";
      action = "<cmd>tablast<cr>";
      options = {
        silent = true;
        desc = "Last Tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>o";
      action = "<cmd>tabonly<cr>";
      options = {
        silent = true;
        desc = "Close Other Tabs";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>f";
      action = "<cmd>tabfirst<cr>";
      options = {
        silent = true;
        desc = "First Tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = {
        silent = true;
        desc = "New Tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>]";
      action = "<cmd>tabnext<cr>";
      options = {
        silent = true;
        desc = "Next Tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = {
        silent = true;
        desc = "Close Tab";
      };
    }
    {
      mode = "n";
      key = "<leader><tab>[";
      action = "<cmd>tabprevious<cr>";
      options = {
        silent = true;
        desc = "Previous Tab";
      };
    }

    # --- Quit ---
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options = {
        silent = true;
        desc = "Quit all windows and exit Neovim";
      };
    }
  ];
}
