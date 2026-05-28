{ pkgs, ... }:
{
  config = {
    plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cpp
        diff
        go
        html
        java
        javascript
        jsdoc
        json
        kotlin
        make
        markdown
        markdown_inline
        nix
        php
        php_only
        printf
        python
        query
        regex
        rust
        svelte
        toml
        tsx
        twig
        typescript
        vim
        vimdoc
        xml
        yaml
      ];
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
    };

    plugins.treesitter-textobjects = {
      enable = true;
      settings = {
        move = {
          enable = true;
          setJumps = true;
          gotoNextStart = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
            "]a" = "@parameter.inner";
          };
          gotoNextEnd = {
            "]F" = "@function.outer";
            "]C" = "@class.outer";
            "]A" = "@parameter.inner";
          };
          gotoPreviousStart = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
            "[a" = "@parameter.inner";
          };
          gotoPreviousEnd = {
            "[F" = "@function.outer";
            "[C" = "@class.outer";
            "[A" = "@parameter.inner";
          };
        };
      };
    };
    # HACK: the treesitter module does not do this for some reason, I think it is a bug but not sure
    autoCmd = [
      {
        event = [ "FileType" ];
        # HACK: this is hardcoded to be the same as the one nixvim generates, if something breaks, its most likely this
        group = "nixvim_treesitter";
        callback.__raw = ''
          function()
            pcall(vim.treesitter.start)
          end
        '';
      }
    ];
  };
}
