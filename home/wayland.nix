{ config, pkgs, lib, ... }:
let cfg = config.tthome.wayland;

in {
  options = {
    tthome.wayland.enable = lib.mkEnableOption "Enable wayland config";
  };
  config = lib.mkIf cfg.enable {
    xsession = { enable = false; };
    programs.swaylock = {
      enable = true;
      # package =  pkgs.swaylock-effects;
    };
    home.packages = with pkgs; [
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      eww-wayland
      hyprpaper

      swww
      satty

      socat
      wev
      wofi
      ironbar
      yambar
      # waylock
      kile-wl
      river-luatile

      # swaylock-effects

    ];
    home.file = {
      hyprland = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/hypr";
        target = "/home/thanawat/.config/hypr";
      };
      sway = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/sway";
        target = "/home/thanawat/.config/sway";

      };
      river = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/river";
        target = "/home/thanawat/.config/river";

      };
      #
      eww = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/eww";
        target = "/home/thanawat/.config/eww";
      };

      waybar = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/waybar";
        target = "/home/thanawat/.config/waybar";
      };

      anyrun = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/anyrun";
        target = "/home/thanawat/.config/anyrun";
      };
      foot = {
        source = config.lib.file.mkOutOfStoreSymlink
          "/home/thanawat/.dotfiles/home/impure/foot";
        target = "/home/thanawat/.config/foot";
      };


    };
  };
}
