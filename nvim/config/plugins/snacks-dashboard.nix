{
  config.plugins.snacks = {
    enable = true;
    settings.dashboard.sections = [
      { section = "header"; }
      {
        icon = " ";
        key = "s";
        desc = "Restore Session";
        action = ":lua require('persistence').load()";
        padding = 1;
      }
      {
        icon = " ";
        title = "Recent Files";
        section = "recent_files";
        indent = 2;
        padding = 1;
      }
      {
        icon = " ";
        title = "Projects";
        section = "projects";
        indent = 2;
        padding = 1;
      }
    ];
  };
}

