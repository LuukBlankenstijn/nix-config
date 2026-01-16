_: {
  config = {
    plugins.snacks = {
      settings = {
        terminal = {
          enabled = true;
          win = {
            wo = {
              winbar = "";
            };
            keys = {
              nav_h = {
                __unkeyed-1 = "<C-h>";
                __unkeyed-2.__raw = ''function() return "<C-\\><C-n><C-w>h" end'';
                desc = "Go to Left Window";
                expr = true;
                mode = "t";
              };
              nav_j = {
                __unkeyed-1 = "<C-j>";
                __unkeyed-2.__raw = ''function() return "<C-\\><C-n><C-w>j" end'';
                desc = "Go to Lower Window";
                expr = true;
                mode = "t";
              };
              nav_k = {
                __unkeyed-1 = "<C-k>";
                __unkeyed-2.__raw = ''function() return "<C-\\><C-n><C-w>k" end'';
                desc = "Go to Upper Window";
                expr = true;
                mode = "t";
              };
              nav_l = {
                __unkeyed-1 = "<C-l>";
                __unkeyed-2.__raw = ''function() return "<C-\\><C-n><C-w>l" end'';
                desc = "Go to Right Window";
                expr = true;
                mode = "t";
              };
            };
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>fT";
        action.__raw = "function() Snacks.terminal() end";
        options.desc = "Terminal (cwd)";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action.__raw = "function() Snacks.terminal(nil, { cwd = Snacks.git.get_root() }) end";
        options.desc = "Terminal (Project Root)";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-_>";
        action.__raw = "function() Snacks.terminal.toggle() end";
        options.desc = "Toggle terminal";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-/>";
        action.__raw = "function() Snacks.terminal.toggle() end";
        options.desc = "Toggle terminal";
      }
    ];
  };
}
