{ pkgs, ... }:
{
  extraPackages = with pkgs; [
    hadolint
    statix
    deadnix
  ];

  plugins.lint = {
    enable = true;
    lintersByFt = {
      dockerfile = [ "hadolint" ];
      nix = [
        "statix"
        "deadnix"
      ];
      php = [ "phpstan" ];
    };
    linters = {
      phpstan = {
        condition.__raw = ''
          function(ctx)
            return vim.fs.find({ "vendor/bin/phpstan" }, { path = ctx.filename, upward = true })[1] ~= nil
          end
        '';
      };
    };
  };

  autoCmd = [
    {
      event = [
        "BufWritePost"
        "BufReadPost"
        "InsertLeave"
      ];
      callback.__raw = "function() require('lint').try_lint() end";
    }
  ];

  extraConfigLua = ''
    local phpstan = require('lint').linters.phpstan

    phpstan.cmd = function()
      return vim.fs.find({ "vendor/bin/phpstan" }, { path = vim.fn.expand("%:p:h"), upward = true })[1]
    end

    phpstan.args = {
      "analyze",
      "--error-format=json",
      "--no-progress",
    }
  '';
}
