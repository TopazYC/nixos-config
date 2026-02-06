{
  description = "My NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/nixos-wsl/release-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Extras (imported directly by modules/hosts that need them)
    dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.inputs.nixpkgs.follows = "nixpkgs-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, ... }@inputs :{
    nixosConfigurations.YC-NixOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        nixos-wsl.nixosModules.wsl
        ./configuration.nix 

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.Topaz = import ./home.nix;

          # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
          # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
          # home-manager.extraSpecialArgs = inputs;
        }
      ];
    };
  };
}
