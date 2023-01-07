{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.printing;
in
with lib;
{
  options = {
    ttsystem.printing = {
      enable = mkEnableOption "Enable printing";
    };
  };
  config = mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };
    services.avahi.enable = true;

  };
}
