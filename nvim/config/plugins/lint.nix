{ pkgs, ... }: {
  extraPackages = with pkgs; [ hadolint statix deadnix ];

  plugins.lint = {
    enable = true;
    lintersByFt = {
      dockerfile = [ "hadolint" ];
      nix = [ "statix" "deadnix" ];
    };
  };

  autoCmd = [{
    event = [ "BufWritePost" "BufReadPost" "InsertLeave" ];
    callback.__raw = "function() require('lint').try_lint() end";
  }];
}
