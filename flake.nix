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
#   emacs-ng.url = "github:emacs-ng/emacs-ng";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, rust-overlay, tree-grepper,  lanzaboote, ... }:
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
          (import self.inputs.emacs-overlay)
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
        thinkpad-t480 = lib.nixosSystem {
          inherit system;
          modules = (lib.my.mapModules (a: a) ./system-modules) ++ [
            ./thinkpad-t480/configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t480
            ({pkgs, ...}:
              {
                # TTsystem things to enable 
                ttsystem.xmonad-de = {
                  enable = true;
                  diskEncryptautoLogin = true;
                };
                ttsystem.gaming.enable = true;
                ttsystem.syncthing.enable = true;
                ttsystem.mobile-debugging.android-enable = true;
                ttsystem.mobile-debugging.apple-enable = true;
                ttsystem.audio.enable = true;
                ttsystem.printing.enable = true;
                ttsystem.zoom.enable = true;
                
              })
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
            lanzaboote.nixosModules.lanzaboote
            # enable stuff here! 
           ({pkgs, ...}:
              
              {
                # Enable system modules
                ttsystem.mobile-debugging.android-enable = true;
                ttsystem.xmonad-de = {
                  enable = false;
                };
                
                ttsystem.syncthing.enable = true;
                ttsystem.gaming.enable = true;
                ttsystem.audio.enable = true;
                ttsystem.printing.enable = true;
                ttsystem.zoom.enable = true;
                # enable version control
                ttsystem.version-control.enable = true;

                # wayland compositors
                programs.hyprland.enable = true;
                programs.sway.enable = true;
                
                # services.xserver.displayManager.sddm.enable = true;

                # make swaylock work
                security.pam.services = { swaylock = { }; };
                # secure boot
                boot.bootspec.enable = true;
                environment.systemPackages = [
                  # For debugging and troubleshooting Secure Boot.
                  pkgs.sbctl
                ];
                # Lanzaboote currently replaces the systemd-boot module.
                # This setting is usually set to true in configuration.nix
                # generated at installation time. So we force it to false
                # for now.
                boot.loader.systemd-boot.enable = lib.mkForce false;

                boot.lanzaboote = {
                  enable = true;
                  pkiBundle = "/etc/secureboot";
                };
            })
            
          ];
        };


      };
      # TODO rewrite this into the nixos module instead of an individual module
      # so I don't have to update twice?
      homeConfigurations = {
       "desktop" = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        #
        pkgs = pkgs;
        modules = [
          ({
            nixpkgs.overlays = [ (import self.inputs.emacs-overlay)  rust-overlay.overlays.default ];
          })
          # TODO move imports over to here.. and rewrite to use cfg instead.
          ./home/home.nix
          ./home/emacs/default.nix
          ./home/shell
          ./home/haskell.nix
          ./home/de.nix
          ./home/hyprland.nix
          # ./home/unity.nix

          ({
            home = {
              inherit username;
              # username = "thanawat";
              homeDirectory = "/home/${username}";
              stateVersion = "22.05";
            };
            # use tree-grepper 
            home.packages = [
              pkgs.tree-grepper
              # Emacsng flake build fails.. so not using it lol
              pkgs.wofi
              pkgs.dolphin
            ];
            # I can change this to emacs-ng instead
            tthome.emacs = {
              enable = true;
              emacsPkg = pkgs.emacs-pgtk;
              # emacsPkg = emacs-ng.packages.x86_64-linux.emacsng;
              # emacsPkg = emacs-ng.packages.x86_64-linux.emacsng;
            };
          })
          # rust
          ./home/rust.nix
        ];
        
       };

       laptop = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        #
        pkgs = pkgs;
        modules = [
          ({
            nixpkgs.overlays = [ (import self.inputs.emacs-overlay)  rust-overlay.overlays.default ];
          })
          # TODO move imports over to here.. and rewrite to use cfg instead.
          ./home/home.nix
          ./home/emacs/default.nix
          ./home/shell
          ./home/haskell.nix
          ./home/de.nix
          ./home/xmonad.nix
          # ./home/unity.nix
          ({
            home = {
              inherit username;
              # username = "thanawat";
              homeDirectory = "/home/${username}";
              stateVersion = "22.05";
            };
            # use tree-grepper 
            home.packages = [
              pkgs.tree-grepper
              # Emacsng flake build fails.. so not using it lol
            ];
            tthome.emacs = {
              enable = true;
              emacsPkg = pkgs.emacs;
            };
          })
          # rust
          ./home/rust.nix
        ];
        
       };
      };

    };
}
