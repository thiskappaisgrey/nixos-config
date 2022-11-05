{
  description = "My nixos configuration and dotfiles";
  inputs =  {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-hardware.url =  "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    # TODO Maybe consider adding the taffybar overlay (but prob not necessary)
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config =  {
          allowUnfree = true;
        };
        # overlays = [ (import self.inputs.emacs-overlay) ];
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
      # TODO rewrite this into the nixos module instead of an individual module
      # so I don't have to update twice?
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        #
        # Not sure how I would get around having to pass down pkgs at every level here to apply overlays and such
        # configuration = import ./home/home.nix;
        pkgs = pkgs;
        modules = [
          ./home/home.nix
          ({
            home = {
              inherit username;
              # username = "thanawat";
              homeDirectory = "/home/${username}";
              stateVersion = "22.05";
            };
            nixpkgs.overlays = [ (import self.inputs.emacs-overlay) ];
          })
          # rust
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ rust-overlay.overlays.default ];
            home.packages = [
              (pkgs.rust-bin.stable.latest.default.override {
              extensions = ["llvm-tools-preview"];
              targets = [ "thumbv7em-none-eabihf" ];
              })
              # for embedded stuff
              pkgs.gdb
              pkgs.minicom
              pkgs.gdb
              pkgs.openocd
              pkgs.rust-analyzer
              # openocd is installed system wide
              # pkgs.cargo-binutils
            ];
          })
        ];
        
      };

    };
}
