{
  config.opts = {
    autowrite = true;
    clipboard = "unnamedplus";
    confirm = true;
    undofile = true;
    undolevels = 10000;

    cursorline = true;
    termguicolors = true;
    number = true;
    relativenumber = false;
    signcolumn = "yes";
    pumblend = 10;
    pumheight = 10;

    expandtab = true;
    tabstop = 4;
    shiftwidth = 4;
    smartindent = true;
    autoindent = true;
    shiftround = true;
    wrap = false;

    ignorecase = true;
    smartcase = true;
    inccommand = "nosplit";
    scrolloff = 4;
    smoothscroll = true;
    mousescroll = "ver:3,hor:6";

    foldmethod = "expr";
    foldexpr = "nvim_treesitter#foldexpr()";
    foldlevel = 99;
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };

    splitbelow = true;
    splitright = true;
    splitkeep = "screen";

    updatetime = 200;
    timeoutlen = 300;
    grepprg = "rg --vimgrep";

    sessionoptions = [
      "buffers"
      "curdir"
      "tabpages"
      "winsize"
      "help"
      "globals"
      "skiprtp"
      "folds"
    ];

    statuscolumn = " %s%l %C ";

  };
}
