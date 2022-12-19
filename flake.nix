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
      # in nixpkgs.lib.extend - uses the makeExtensible pattern, which allows attribute sets to be extended.
      # uses the fixed point combinator - the self is the current attribute set, and the super is the "old" attribute set
      # this way, I can extend the nix lib to include my lib functions
      lib = nixpkgs.lib.extend (self: super: {my = import ./lib.nix {inherit self pkgs; lib = self; }; });
      username =  "thanawat";
    in {
      lib = lib;
      # nixosModules =   {ttsystem = {}; } // lib.my.mapModules import ./system-modules;
      nixosConfigurations = {
        thanawat = lib.nixosSystem {
          inherit system;
          modules =  [
            # ./system/configuration.nix
            # self.nixosModules
            # nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ];

        };
        # my um560 configuration
        um560 = lib.nixosSystem {
          inherit system;
          inherit lib;
          
          # figured it out..
          # lib.my.mapModules (a: a) ./system-modules - basically returns all of the absolute nix paths in ./system-modules# then, I can import them using this:
          modules =  (lib.my.mapModules (a: a) ./system-modules) ++ [
            ./um560/configuration.nix
            # enable stuff here! 
           ({pkgs, ...}:
              
              {
                ttsystem.mobile-debugging.android-enable = true;
                # this kind of works?
                ttsystem.simple-module.enable = true;
                ttsystem.xmonad-de = {
                  enable = true;
                  diskEncryptautoLogin = true;
                };
                ttsystem.syncthing.enable = true;
            })
            
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
              # Emacsng flake build fails.. so not using it lol
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
