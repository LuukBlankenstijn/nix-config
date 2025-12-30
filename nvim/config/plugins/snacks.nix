{
  config = {
    plugins.snacks = {
      settings = {
        bigfile.enabled = true;
        quickfile.enabled = true;
        profiler.enabled = true;
        scroll.enabled = true;
        image.enable = true;
        notifier.enable = true;
        indent.enable = true;
        words.enable = true;
      };
    };
    keymaps = [
      # --- Snacks Zoom (Temporary Maximize) ---
      {
        mode = "n";
        key = "<leader>wm";
        action.__raw = "function() Snacks.toggle.zoom():toggle() end";
        options.desc = "Toggle Maximize Window (Zoom)";
      }
      {
        mode = "n";
        key = "<leader>uZ";
        action.__raw = "function() Snacks.toggle.zoom():toggle() end";
        options.desc = "Toggle Maximize Window (Zoom)";
      }
    ];
  };
}
