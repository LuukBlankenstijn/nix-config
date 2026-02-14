{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ssh-keys = {
      url = "https://github.com/LuukBlankenstijn.keys";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprshell = {
      url = "github:H3rmt/hyprshell?ref=hyprshell-release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim.url = "path:./nvim";

    ranger-archives = {
      url = "github:maximtrp/ranger-archives/0b1cfa9a77412c3b51da5b1b213c672227f9fbb4";
      flake = false;
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.zenbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          inputs.impermanence.nixosModules.impermanence
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.luuk = import ./users/luuk/desktop.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
          ./hosts/zenbook/configuration.nix
          (_: {
            virtualisation.vmVariant = {
              virtualisation.memorySize = 8192;
              virtualisation.cores = 4;
            };
          })
        ];

      };
      nixosConfigurations.probook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          inputs.impermanence.nixosModules.impermanence
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.luuk = import ./users/luuk/desktop.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
          ./hosts/probook/configuration.nix
          (_: {
            virtualisation.vmVariant = {
              virtualisation.memorySize = 8192;
              virtualisation.cores = 4;
            };
          })
        ];
      };
    };
}
