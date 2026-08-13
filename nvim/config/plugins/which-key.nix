{
  config = {
    plugins.which-key = {
      enable = true;

      settings = {
        preset = "helix";
        spec = [{
          mode = [ "n" "x" ];
          __unkeyed-1 = [
            {
              __unkeyed-1 = "<leader><tab>";
              group = "tabs";
            }
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
            }
            {
              __unkeyed-1 = "<leader>c";
              group = "Programming & Code";
            }
            {
              __unkeyed-1 = "<leader>d";
              group = "Debug";
            }
            {
              __unkeyed-1 = "<leader>dp";
              group = "Profiler";
            }
            {
              __unkeyed-1 = "<leader>f";
              group = "File & Find";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed-1 = "<leader>gh";
              group = "Git Hunks";
            }
            {
              __unkeyed-1 = "<leader>l";
              group = "Live Share";
            }
            {
              __unkeyed-1 = "<leader>q";
              group = "Quit";
            }
            {
              __unkeyed-1 = "<leader>s";
              group = "Search";
            }
            {
              __unkeyed-1 = "<leader>sn";
              group = "Noice";
            }
            {
              __unkeyed-1 = "<leader>u";
              group = "UI";
            }
            {
              __unkeyed-1 = "<leader>x";
              group = "Diagnostics & Quickfix";
            }
            {
              __unkeyed-1 = "g";
              group = "Go To...";
            }
            {
              __unkeyed-1 = "z";
              group = "Folds";
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "Windows";
              proxy = "<c-w>";
              expand.__raw = ''
                function() return require("which-key.extras").expand.win() end'';
            }
          ];
        }];
      };
    };
    # required dependency
    plugins.mini-icons.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>?";
        action.__raw =
          ''function() require("which-key").show({ global = false }) end'';
        options.desc = "Show: Buffer Local Keymaps";
      }
      {
        mode = "n";
        key = "<c-w><space>";
        action.__raw = ''
          function() require("which-key").show({ keys = "<c-w>", loop = true }) end'';
        options.desc = "Window: Hydra Mode (Stay open)";
      }
    ];
  };

}
