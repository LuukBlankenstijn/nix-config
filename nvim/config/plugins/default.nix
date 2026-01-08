{
  imports = [
    ./blink.nix
    ./buffer-line.nix
    ./conform.nix
    ./flash.nix
    ./fzf-lua.nix
    ./gitsigns.nix
    ./lint.nix
    ./lspconfig.nix
    ./lualine.nix
    ./mini-pairs.nix
    ./neo-tree.nix
    ./noice.nix
    ./oil.nix
    ./persistence.nix
    ./snacks-dashboard.nix
    ./snacks-image.nix
    ./snacks-scratch.nix
    ./snacks-terminal.nix
    ./snacks.nix
    ./todo-comments.nix
    ./treesitter.nix
    ./trouble.nix
    ./which-key.nix
  ];

  config.plugins.ts-comments.enable = true;
  config.plugins.rustaceanvim.enable = true;

}
