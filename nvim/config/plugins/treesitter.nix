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
        javascript
        jsdoc
        json
        jsonc
        make
        markdown
        markdown_inline
        nix
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
  };
}
