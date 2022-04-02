{
  description = "My nixos configuration and dotfiles";
  inputs =  {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-hardware.url =  "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config =  {
          allowUnfree = true;
        };
        overlays = [ (import self.inputs.emacs-overlay) ];
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
        #
        # Not sure how I would get around having to pass down pkgs at every level here to apply overlays and such
        configuration = import ./home/home.nix;
        pkgs = pkgs;
        inherit system username;
        homeDirectory = "/home/${username}";
        stateVersion = "22.05";
      };

    };
}
