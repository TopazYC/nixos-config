{
  description = "Topaz's NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-wsl.url = "github:nix-community/nixos-wsl/release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
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
  
    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/catppuccin/nix
    catppuccin = {
      url = "github:catppuccin/nix/v26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

# -------------- Gaming --------------------- #

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mysecrets = {
      url = "git+ssh://git@github.com/TopazYC/secrets.git?shallow=1";
      flake = false;
    };
    wallpapers = {
      url = "git+ssh://git@github.com/TopazYC/wallpapers.git?shallow=1";
      flake = false;
    };


    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: import ./outputs inputs;


#  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, sops-nix, mysecrets, wallpapers, noctalia, ... }@inputs :{
#    nixosConfigurations.simple = nixpkgs.lib.nixosSystem {
#      system = "x86_64-linux";
#      specialArgs = {
#        inherit inputs;
#      };
#      modules = [ 
#        ./simple/configuration.nix 
#        ./simple/hardware-configuration.nix
#      ];
#    };
#    nixosConfigurations.Fisher = nixpkgs.lib.nixosSystem {
#      system = "x86_64-linux";
#      specialArgs = {
#        inherit inputs nixpkgs-unstable sops-nix mysecrets wallpapers noctalia;
#      };
#      modules = [ 
#        ./fisher/configuration.nix 
#        ./fisher/hardware-configuration.nix
#        ./secret
#
#        home-manager.nixosModules.home-manager
#
#        {
#          home-manager.useGlobalPkgs = true;
#          home-manager.useUserPackages = true;
#          home-manager.users.Topaz = import ./fisher/home.nix;
#          home-manager.extraSpecialArgs = {
#             inherit  inputs noctalia wallpapers;
#          };
#        }
#      ];
#    };
#    nixosConfigurations.WSL2-NixOS = nixpkgs.lib.nixosSystem {
#      system = "x86_64-linux";
#      modules = [ 
#        nixos-wsl.nixosModules.wsl
#        ./WSL/configuration.nix 
#
#        home-manager.nixosModules.home-manager
#
#        {
#          home-manager.useGlobalPkgs = true;
#          home-manager.useUserPackages = true;
#          home-manager.users.Topaz = import ./WSL/home.nix;
#          # home-manager.extraSpecialArgs = inputs;
#        }
#      ];
#    };
#
#    nixosConfigurations.HyperV = nixpkgs.lib.nixosSystem {
#
#      system = "x86_64-linux";
#      specialArgs = {
#        inherit inputs nixpkgs-unstable sops-nix mysecrets wallpapers noctalia;
#      };
#      modules = [ 
#        ./HyperV/configuration.nix 
#        ./HyperV/hardware-configuration.nix
#        ./secret
#
#        home-manager.nixosModules.home-manager
#
#        {
#          home-manager.useGlobalPkgs = true;
#          home-manager.useUserPackages = true;
#          home-manager.users.Topaz = import ./HyperV/home.nix;
#          home-manager.extraSpecialArgs = {
#             inherit  inputs noctalia wallpapers;
#          };
#        }
#      ];
#    };
#  };
}
