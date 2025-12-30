{
  config = {
    plugins.oil = {
      enable = true;
      settings = {
        delete_to_trash = true;
        skip_confirm_for_simple_edits = true;
        lsp_file_methods.autosave_changes = "unmodified";
        view_options.is_hidden_file.__raw = ''
          function(name, bufnr)
            local heavy_folders = { "node_modules", ".git", "target", "build", ".next", ".cache" }
            for _, folder in ipairs(heavy_folders) do
              if name == folder then return true end
            end

            if name == ".gitignore" or name:match("^%.env") then
              return false
            end

            return vim.startswith(name, ".")
          end
        '';
        keymaps = { "q" = "actions.close"; };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<CMD>Oil --float<CR>";
        options = { desc = "Open parent directory"; };
      }
      {
        mode = "n";
        key = "q";
        action = "actions.close";
        options = { desc = "Close Oil buffer"; };
      }
    ];
    autoCmd = [{
      event = "User";
      pattern = "OilActionsPost";
      callback.__raw = ''
        function(event)
          if event.data.actions[1].type == "move" then
            Snacks.rename.on_rename_file(
              event.data.actions[1].src_url, 
              event.data.actions[1].dest_url
            )
          end
        end
      '';
    }];
  };
}
