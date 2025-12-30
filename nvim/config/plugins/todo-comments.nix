{
  config = {
    plugins.todo-comments.enable = true;
    keymaps = [
      {
        mode = "n";
        key = "]t";
        action.__raw = ''function() require("todo-comments").jump_next() end'';
        options = {
          silent = true;
          desc = "Next Todo Comment";
        };
      }
      {
        mode = "n";
        key = "[t";
        action.__raw = ''function() require("todo-comments").jump_prev() end'';
        options = {
          silent = true;
          desc = "Previous Todo Comment";
        };
      }
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>TodoFzfLua<cr>";
        options = {
          silent = true;
          desc = "Search: Todo Comments (All)";
        };
      }
      {
        mode = "n";
        key = "<leader>sT";
        action = "<cmd>TodoFzfLua keywords=TODO,FIX,FIXME<cr>";
        options = {
          silent = true;
          desc = "Search: Todo/Fix/Fixme";
        };
      }

      # Trouble integration
      {
        mode = "n";
        key = "<leader>xt";
        action = "<cmd>Trouble todo toggle<cr>";
        options = {
          silent = true;
          desc = "Diagnostics: Todo (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xT";
        action =
          "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>";
        options = {
          silent = true;
          desc = "Diagnostics: Todo/Fix/Fixme (Trouble)";
        };
      }
    ];
  };
}
