{
  description = "Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      configModule = import ./config;
      loadConfig = path:
        let imported = import path;
        in if builtins.isFunction imported then
          imported { inherit pkgs inputs; }
        else
          imported;
    in {
      packages.${system}.default =
        nixvim.legacyPackages.${system}.makeNixvimWithModule {
          inherit pkgs;
          module = configModule;
          extraSpecialArgs = { inherit inputs; };
        };

      homeModules.default = { pkgs, ... }: {
        imports = [ nixvim.homeModules.nixvim ];

        programs.nixvim = {
          enable = true;
          imports = [ ./config ];
        };
      };
    };
}
