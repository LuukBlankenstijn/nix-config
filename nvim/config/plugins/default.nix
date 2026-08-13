{
  imports = [
    ./blink.nix
    ./buffer-line.nix
    ./codesettings.nix
    ./conform.nix
    ./flash.nix
    ./fzf-lua.nix
    ./gitsigns.nix
    ./live-share.nix
    ./lint.nix
    ./lspconfig.nix
    ./lualine.nix
    ./markdown-preview.nix
    ./mini-pairs.nix
    ./neo-tree.nix
    ./neotest.nix
    ./noice.nix
    ./persistence.nix
    ./rustaceanvim.nix
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
  config.plugins = {
    ts-comments.enable = true;
    helm.enable = true;
    typst-preview.enable = true;
    typst-vim.enable = true;
  };

}
