{
  config = {
    plugins.markdown-preview = {
      enable = true;
      settings = {
        autoStart = 0;
        theme = "dark";
        port = "9898";
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>cp";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options = {
          desc = "Markdown Preview";
          silent = true;
        };
      }
    ];

    autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [ "markdown" ];
        callback.__raw = ''
          function()
            vim.keymap.set('n', '<leader>cp', '<cmd>MarkdownPreviewToggle<cr>', { buffer = true, desc = "Markdown Preview" })
          end
        '';
      }
    ];
  };
}
