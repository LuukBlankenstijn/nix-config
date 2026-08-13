{
  config = {
    plugins.live-share = {
      enable = true;
      callSetup = true;
      username = "Luuk";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>lh";
        action = "<cmd>LiveShareHostStart<cr>";
        options.desc = "Live Share: Host Session";
      }
      {
        mode = "n";
        key = "<leader>lj";
        action = ":LiveShareJoin ";
        options.desc = "Live Share: Join Session";
      }
      {
        mode = "n";
        key = "<leader>ls";
        action = "<cmd>LiveShareStop<cr>";
        options.desc = "Live Share: Stop Session";
      }
      {
        mode = "n";
        key = "<leader>lp";
        action = "<cmd>LiveSharePeers<cr>";
        options.desc = "Live Share: Show Peers";
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>LiveShareFollow<cr>";
        options.desc = "Live Share: Follow Peer";
      }
      {
        mode = "n";
        key = "<leader>lF";
        action = "<cmd>LiveShareUnfollow<cr>";
        options.desc = "Live Share: Unfollow";
      }
      {
        mode = "n";
        key = "<leader>lw";
        action = "<cmd>LiveShareWorkspace<cr>";
        options.desc = "Live Share: Open Workspace";
      }
      {
        mode = "n";
        key = "<leader>lt";
        action = "<cmd>LiveShareTerminal<cr>";
        options.desc = "Live Share: Shared Terminal";
      }
    ];
  };
}
