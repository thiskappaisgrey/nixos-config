{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.gaming;
in
with lib;
{
  options = {
    ttsystem.gaming = {
      enable = mkEnableOption "Steam and gaming - installed system-wide for steam-run.";
    };
  };
  
  config = mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraPkgs = pkgs: with pkgs; [ libxkbcommon
                                         mesa
                                         # wayland
                                         zlib
                                         libpng ];
        };
      };
    };
    nixpkgs.overlays = [
      (self: super: {
        steam-run = (super.steam.override {
          extraLibraries = pkgs:
            with pkgs; [
              libxkbcommon
              mesa
              # wayland
              zlib
              libpng
            ];
        }).run;
      })
    ];

    environment.systemPackages = with pkgs; [
      steam-run
    ];
      programs.steam.enable = true;

  };
}
