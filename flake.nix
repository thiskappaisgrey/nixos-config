{
  description = "My nixos configuration and dotfiles";
  inputs =  {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-hardware.url =  "github:NixOS/nixos-hardware/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    # TODO use local flake to support my own languages instead
    tree-grepper.url = "github:BrianHicks/tree-grepper";
    # TODO Maybe consider adding the taffybar overlay (but prob not necessary)
    emacs-ng.url = "github:emacs-ng/emacs-ng";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, rust-overlay, tree-grepper, emacs-ng, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config =  {
          allowUnfree = true;
        };
        # Interesting, this is how you consume a "eachDefaultSystem" flake. you have to specify the system in the overlay / package.
        # TODO tree grepper defines it's own tree-sitter binaries, I wonder if I can just use those rather than some other one?
        overlays = [
          tree-grepper.overlay.x86_64-linux
          # emacs-ng.overlays.default
                   ];
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
          # TODO move imports over to here.. and rewrite to use cfg instead.
          ./home/home.nix
          ({
            home = {
              inherit username;
              # username = "thanawat";
              homeDirectory = "/home/${username}";
              stateVersion = "22.05";
            };
            nixpkgs.overlays = [ (import self.inputs.emacs-overlay)  ];
            # use tree-grepper 
            home.packages = [
              pkgs.tree-grepper
              # TODO try the rust version tmr
              # emacs-ng.packages.x86_64-linux.emacsng-rust
              emacs-ng.packages.x86_64-linux.emacsng
              # emacs-ng.apps.emacsng-rust.x86_64-linux
            ];
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
