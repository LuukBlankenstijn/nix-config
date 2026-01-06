{ inputs, ... }: {
  programs.ranger = {
    enable = true;
    plugins = [{
      name = "archives";
      src = inputs.ranger-archives;
    }];
  };
}
