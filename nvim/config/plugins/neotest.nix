{
  plugins.neotest = {
    enable = true;
    adapters.pest = {
      enable = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>tn";
      action.__raw = ''
        function()
          require('neotest').run.run()
        end
      '';
      options.desc = "Run the test hovering over";
    }
    {
      mode = "n";
      key = "<leader>ta";
      action.__raw = ''
        function()
          require('neotest').run.run({ suite = true })
        end
      '';
      options.desc = "Run the entire test suit";
    }
  ];
}
