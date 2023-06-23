{config, pkgs, lib, ...}:
{
  xsession ={
    enable = false;
  };
  programs.swaylock = {
    enable = true;
    # package =  pkgs.swaylock-effects;
  };
  home.packages = with pkgs; [
    waybar
    eww-wayland
    hyprpaper
    swww
    # waylock
    # swaylock-effects
    
  ];
  # copied from:  https://github.com/fufexan/dotfiles
  services.swayidle =
    let
        suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
    in
    {
    enable = true;
        events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF --image /home/thanawat/.dotfiles/pikachu.jpg";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -fF --image /home/thanawat/.dotfiles/pikachu.jpg";
      }
    ];
    timeouts = [
      {
        timeout = 330;
        command = suspendScript.outPath;
      }
    ];
  };
  
  home.file = {
    hyprland = {
        source =       config.lib.file.mkOutOfStoreSymlink "/home/thanawat/.dotfiles/home/impure/hypr";
        target = "/home/thanawat/.config/hypr";
    };
    sway = {
        source =       config.lib.file.mkOutOfStoreSymlink "/home/thanawat/.dotfiles/home/impure/sway";
        target = "/home/thanawat/.config/sway";

    };

    eww = {
        source =       config.lib.file.mkOutOfStoreSymlink "/home/thanawat/.dotfiles/home/impure/eww";
        target = "/home/thanawat/.config/eww";
  };
      };
}
