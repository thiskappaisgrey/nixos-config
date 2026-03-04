{ config, pkgs, lib, ... }:
let cfg = config.ttsystem.udev;
in with lib; {
  options = {
    ttsystem.udev = {
      enable = mkEnableOption "Enable udev rules for embedded development";

    };
  };
  config = mkIf cfg.enable {

    services.udev = {
      packages = [ pkgs.picoprobe-udev-rules ];
      extraRules = lib.mkMerge [
        # ''
        #   SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"''
        # # adafruit tft.. hopefully this works?
        # ''
        #   SUBSYSTEMS=="usb|tty|hidraw", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="810f", MODE="664", GROUP="plugdev" ''
        # ST Link
        # ''ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0666"''
        # Pi pico
        # ''SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE:="666"''
        # ''SUBSYSTEM=="tty", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0005", SYMLINK+="pico"''
      ];

    };

  };

}

