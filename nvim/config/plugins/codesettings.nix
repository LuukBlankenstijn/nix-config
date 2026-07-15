{
  plugins.codesettings.enable = true;

  extraConfigLua = ''
    vim.lsp.config("rust-analyzer", {
      before_init = function(init_params, config)
        require("codesettings").with_local_settings(config.name, config)
        if config.default_settings and config.default_settings[config.name] then
          init_params.initializationOptions = config.default_settings[config.name]
        end
      end,
    })
  '';
}
