{ osConfig, lib, inputs, ... }:
lib.mkIf osConfig.cfg.userConfig.ranger.enable {
  programs.ranger = {
    enable = true;
    plugins = [
      {
        name = "archives";
        src = inputs.ranger-archives;
      }
    ];
  };
}
