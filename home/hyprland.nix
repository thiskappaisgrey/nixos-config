{config, pkgs, lib, ...}:
{
  xsession ={
    enable = false;
  };

  home.packages = with pkgs; [
    waybar
    eww-wayland
    hyprpaper
    swww
  ];
  home.file = {
    hyprland = {
        source =       config.lib.file.mkOutOfStoreSymlink "/home/thanawat/.dotfiles/home/impure/hypr";
        target = "/home/thanawat/.config/hypr";
  };

    eww = {
        source =       config.lib.file.mkOutOfStoreSymlink "/home/thanawat/.dotfiles/home/impure/eww";
        target = "/home/thanawat/.config/eww";
  };
      };
}
