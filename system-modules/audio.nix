{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.audio;
in
with lib;
{
  options = {
    ttsystem.audio = {
      enable = mkEnableOption "Enable audio";
      
    };
  };
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # hardware.pulseaudio = {
    #   enable = true;
    #   package = pkgs.pulseaudioFull;
    #  };
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

  };
  
}
