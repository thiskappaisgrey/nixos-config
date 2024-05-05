{
  description = "My nixos configuration and dotfiles";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    emacs-overlay.url = "github:nix-community/emacs-overlay/master";

    rust-overlay.url = "github:oxalica/rust-overlay";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # TODO use local flake to support my own languages instead
    # TODO Maybe consider adding the taffybar overlay (but prob not necessary)
    #   emacs-ng.url = "github:emacs-ng/emacs-ng";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.rust-overlay.follows = "rust-overlay";
    };

    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, rust-overlay
    , lanzaboote, anyrun, disko, nixos-cosmic, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        # Interesting, this is how you consume a "eachDefaultSystem" flake. you have to specify the system in the overlay / package.
        # TODO tree grepper defines it's own tree-sitter binaries, I wonder if I can just use those rather than some other one?
        overlays = [
          (import self.inputs.emacs-overlay)
          # emacs-ng.overlays.default
        ];
      };
      # in nixpkgs.lib.extend - uses the makeExtensible pattern, which allows attribute sets to be extended.
      # uses the fixed point combinator - the self is the current attribute set, and the super is the "old" attribute set
      # this way, I can extend the nix lib to include my lib functions
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib.nix {
          inherit self pkgs;
          lib = self;
        };
      });
      username = "thanawat";

      home-modules = import ./home/modules-list.nix;
    in {
      lib = lib;
      # nixosModules =   {ttsystem = {}; } // lib.my.mapModules import ./system-modules;
      nixosConfigurations = {
        "thanawat-thinkpad" = lib.nixosSystem {
          inherit system;
          modules = (lib.my.getModules ./system-modules) ++ [
            ./thinkpad-t480/configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t480
            ({ pkgs, ... }: {
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
        "thanawat-um560" = lib.nixosSystem {
          inherit system;
          inherit lib;

          # figured it out..
          # lib.my.mapModules (a: a) ./system-modules - basically returns all of the absolute nix paths in ./system-modules# then, I can import them using this:
          modules = (lib.my.getModules ./system-modules) ++ [
            ./um560/configuration.nix
            lanzaboote.nixosModules.lanzaboote
            # enable stuff here! 
            ({ pkgs, ... }:

              {
                # Enable system modules
                ttsystem.mobile-debugging.android-enable = true;
                ttsystem.xmonad-de = {
                  enable = false;
                  diskEncryptautoLogin = false;
                };
                # programs.nix-ld.enable = true;

                ttsystem.nix-ld.enable = true;
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
                programs.river.enable = true;
                documentation.dev.enable = true;
                # services.xserver.displayManager.sddm.enable = true;

                # make swaylock work
                security.pam.services = { swaylock = { }; };
                # secure boot
                boot.bootspec.enable = true;
                environment.systemPackages = [
                  # For debugging and troubleshooting Secure Boot.
                  pkgs.sbctl

                  pkgs.hikari
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

        "framework-thanawat" = lib.nixosSystem {
          inherit system;
          inherit lib;

          # figured it out..
          # lib.my.mapModules (a: a) ./system-modules - basically returns all of the absolute nix paths in ./system-modules# then, I can import them using this:
          modules = (lib.my.getModules ./system-modules) ++ [
            ./framework/configuration.nix
            nixos-hardware.nixosModules.framework-13-7040-amd
            disko.nixosModules.disko
            ./disk-config.nix
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [
                  "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
                ];
              };
            }
            nixos-cosmic.nixosModules.default
            # enable stuff here! 
            ({ pkgs, ... }:

              {
                # Enable system modules
                # ttsystem.mobile-debugging.android-enable = true;
                ttsystem.xmonad-de = {
                  enable = false;
                  diskEncryptautoLogin = false;
                };
                # programs.nix-ld.enable = true;

                ttsystem.nix-ld.enable = true;
                ttsystem.syncthing.enable = true;
                ttsystem.gaming.enable = true;
                ttsystem.audio.enable = true;

                # services.desktopManager.cosmic.enable = true;
                # services.displayManager.cosmic-greeter.enable = true;
                # environment.systemPackages = [ pkgs.cosmic-greeter ];
                # security.pam.services.cosmic-greeter = { };

                hardware.pulseaudio.enable = false;
                ttsystem.printing.enable = true;
                ttsystem.zoom.enable = true;
                # enable version control
                ttsystem.version-control.enable = true;

                # wayland compositors
                programs.hyprland.enable = true;
                programs.sway.enable = true;
                programs.river.enable = true;
                documentation.dev.enable = true;
                # services.xserver.displayManager.sddm.enable = true;

                # make swaylock work
                security.pam.services = {
                  swaylock = {
                    text = ''
                      auth sufficient pam_unix.so try_first_pass likeauth nullok
                      auth sufficient pam_fprintd.so
                      auth include login
                    '';
                  };
                };

                # TODO: fprintd..?
                services.fprintd.enable = true;
                # enable power-profiles-daemon
              })
          ];
        };

        # Installation iso 
        # TODO: copy my dotfiles into the iso
        exampleIso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ({ pkgs, ... }: {
              environment.systemPackages = [
                pkgs.neovim
                pkgs.git
                disko.outputs.packages."${system}".default
              ];
              environment.etc = { dotfiles.source = ./.; };
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

          # TODO: I need to rework this...
          modules = home-modules ++ [
            ({
              nixpkgs.overlays = [
                (import self.inputs.emacs-overlay)
                rust-overlay.overlays.default
              ];
            })
            ({
              home = {
                inherit username;
                # username = "thanawat";
                homeDirectory = "/home/${username}";
                stateVersion = "22.05";
              };
              home.packages =
                [ anyrun.packages.${system}.anyrun-with-all-plugins ];
              # I can change this to emacs-ng instead
              tthome.emacs = {
                enable = true;
                emacsPkg =
                  (pkgs.emacs-pgtk.override { withTreeSitter = true; });
                # emacsPkg = emacs-ng.packages.x86_64-linux.emacsng;
                # emacsPkg = emacs-ng.packages.x86_64-linux.emacsng;
              };
              tthome.dev-tools.enable = true;
              tthome.home.enable = true;

              # tthome.de.audio.enable = true;
              # tthome.de.video-editing.enable = true;
              tthome.de.drawing.enable = true;
              tthome.wayland.enable = true;
              tthome.design.enable = true;

            })
            # rust
            ./home/rust.nix
          ];

        };

        "framework" = home-manager.lib.homeManagerConfiguration {
          # Specify the path to your home configuration here
          #
          pkgs = pkgs;

          # TODO: I need to rework this...
          modules = home-modules ++ [
            ({
              nixpkgs.overlays = [
                (import self.inputs.emacs-overlay)
                rust-overlay.overlays.default
              ];
            })
            ({
              home = {
                inherit username;
                # username = "thanawat";
                homeDirectory = "/home/${username}";
                stateVersion = "22.05";
              };
              home.packages =
                [ anyrun.packages.${system}.anyrun-with-all-plugins ];
              # I can change this to emacs-ng instead
              tthome.emacs = {
                enable = true;
                emacsPkg = pkgs.emacs29;
                # emacsPkg = emacs-ng.packages.x86_64-linux.emacsng;
                # emacsPkg = emacs-ng.packages.x86_64-linux.emacsng;
              };
              tthome.dev-tools.enable = true;
              tthome.home.enable = true;
              tthome.de.audio.enable = true;

              # tthome.de.audio.enable = true;
              # tthome.de.video-editing.enable = true;
              tthome.de.drawing.enable = true;
              tthome.wayland.enable = true;

            })
            # rust
            ./home/rust.nix
          ];

        };

        laptop = home-manager.lib.homeManagerConfiguration {
          # Specify the path to your home configuration here
          #
          pkgs = pkgs;
          modules = home-manager ++ [
            ({
              nixpkgs.overlays = [
                (import self.inputs.emacs-overlay)
                rust-overlay.overlays.default
              ];
            })
            # TODO move imports over to here.. and rewrite to use cfg instead.
            ({
              home = {
                inherit username;
                # username = "thanawat";
                homeDirectory = "/home/${username}";
                stateVersion = "22.05";
              };
              home.packages = [ ];
              tthome.emacs = {
                enable = true;
                emacsPkg = pkgs.emacs;
              };
              tthome.dev-tools.enable = true;
              tthome.home.enable = true;
            })
          ];

        };
      };

    };

}
