{
  description = "My NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-wsl.url = "github:nix-community/nixos-wsl/release-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager-wsl.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Extras (imported directly by modules/hosts that need them)
    dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.inputs.nixpkgs.follows = "nixpkgs-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  

    mysecrets = {
      url = "github:TopazYC/secrets";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, sops-nix, mysecrets, ... }@inputs :{
    nixosConfigurations.YC-NixOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        nixos-wsl.nixosModules.wsl
        ./WSL/configuration.nix 

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.Topaz = import ./WSL/home.nix;
          # home-manager.extraSpecialArgs = inputs;
        }
      ];
    };

    nixosConfigurations.HyperV = nixpkgs.lib.nixosSystem {

      system = "x86_64-linux";
      specialArgs = {
        inherit nixpkgs-unstable sops-nix mysecrets;
      };
      modules = [ 
        ./HyperV/configuration.nix 
        ./HyperV/hardware-configuration.nix
        ./secret

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.Topaz = import ./HyperV/home.nix;
          # home-manager.extraSpecialArgs = inputs;
        }
      ];
    };
  };
}
