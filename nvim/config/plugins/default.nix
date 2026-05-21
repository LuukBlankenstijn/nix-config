{
  imports = [
    ./blink.nix
    ./buffer-line.nix
    ./conform.nix
    ./flash.nix
    ./gitsigns.nix
    ./lint.nix
    ./lspconfig.nix
    ./lualine.nix
    ./markdown-preview.nix
    ./mini-pairs.nix
    ./neotest.nix
    ./noice.nix
    ./oil.nix
    ./persistence.nix
    ./rustaceanvim.nix
    ./snacks-dashboard.nix
    ./snacks-image.nix
    ./snacks-picker.nix
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
