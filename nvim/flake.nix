{
  description = "NeoVim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "intelephense" ];
      };
      configModule = import ./config;
    in
    {
      packages.${system}.default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit pkgs;
        module = configModule;
        extraSpecialArgs = { inherit inputs; };
      };

      homeModules.default =
        { pkgs, ... }:
        {
          imports = [ nixvim.homeModules.nixvim ];

          programs.nixvim = {
            enable = true;
            defaultEditor = true;
            imports = [ ./config ];
          };
        };
    };
}
