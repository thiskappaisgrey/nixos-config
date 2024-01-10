{ config, pkgs, lib, ... }:
let cfg = config.tthome.xmonad;
in with lib; {

  options = { tthome.xmonad = { enable = mkEnableOption "Enable XMonad"; }; };

  config = mkIf cfg.enable {
    services.taffybar.enable = true;
    services.screen-locker = {
      enable = true;
      # inactiveInterval = 30;
      lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
      xautolock.extraOptions = [ "Xautolock.killer: systemctl suspend" ];
      xautolock.enable = true;
    };
    xsession = {
      enable = true;
      importedVariables = [ "GDK_PIXBUF_ICON_LOADER" ];
      preferStatusNotifierItems = true;
    };
    programs.autorandr = { enable = true; };
    services.picom = {
      enable = true;
      fade = true;
      vSync = true;
      # experimentalBackends = true;
      fadeDelta = 5;
      backend = "glx";
    };
    home.packages = with pkgs; [
      taffybar
      haskellPackages.status-notifier-item

      xclip
      xorg.xmodmap

      xorg.xwininfo

      rofi
      rofi-pass
      rofimoji

      caffeine-ng
      flameshot
    ];

    home.file = {
      xmonad.source = config.lib.file.mkOutOfStoreSymlink
        "/home/thanawat/.dotfiles/home/impure/xmonad/";
      xmonad.target = "/home/thanawat/.xmonad";

      taffybar.source = config.lib.file.mkOutOfStoreSymlink
        "/home/thanawat/.dotfiles/home/impure/taffybar/";
      taffybar.target = "/home/thanawat/.config/taffybar";
    };

  };

}
