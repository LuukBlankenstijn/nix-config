{ ... }: {
  imports = [
    ./theme.nix
    ./plugins
    ./opts.nix
    ./globals.nix
    ./lsp.nix
    ./keybinds.nix
    ./autocmd.nix
  ];
  config = { clipboard.providers.wl-copy.enable = true; };
}
