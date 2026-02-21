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
        # Only run if a config file is found
        condition.__raw = ''
          function(ctx)
            return vim.fs.find({ "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" }, { path = ctx.filename, upward = true })[1] ~= nil
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
        local local_bin = vim.fs.find({ "vendor/bin/phpstan" }, { path = vim.fn.expand("%:p:h"), upward = true })[1]
        return local_bin or "phpstan"
      end

      phpstan.args = {
        "analyze",
        "--error-format=json",
        "--no-progress",
      }
  '';
}
