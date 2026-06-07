{
  description = "NixOS config (niri + quickshell)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    helium-nix.url = "github:AlvaroParker/helium-nix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      user = "ilya";
      dotfiles = "/home/${user}/git/nixos-config";

      mkHost = configName: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs configName user dotfiles; };
        modules = [
          { nixpkgs.overlays = [ (final: prev: { helium = inputs.helium-nix.packages.${system}.helium; }) ]; }
          ./hosts/${configName}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs configName user dotfiles; };
            home-manager.users.${user} = import ./home/home.nix;
          }
        ];
      };
    in {
      nixosConfigurations = {
        thinkpad = mkHost "thinkpad";
        desktop = mkHost "desktop";
      };
    };
}
