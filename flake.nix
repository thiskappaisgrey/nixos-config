{
  description = "My nixos configuration and dotfiles";
  inputs =  {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-hardware.url =  "github:NixOS/nixos-hardware/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config =  { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
      username =  "thanawat";
    in {
      nixosConfigurations = {
        thanawat = lib.nixosSystem {
          inherit system;
          modules =  [
            ./system/configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ];

        };
      };
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home/home.nix { pkgs = pkgs; config = {}; };
        inherit system username;
        homeDirectory = "/home/${username}";
        stateVersion = "22.05";
      };

    };
}
