# TODO - run desktop as a git/darcs/pijul server
# user for version control
{config, pkgs, lib, ...}:
let
  cfg = config.ttsystem.version-control;
in
with lib;
{
  options = {
    ttsystem.version-control = {
      enable = mkEnableOption "Enable version control user";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      # patch based version control
      pijul
      darcs
    ];
    # enable openssh
    services.openssh = {
      enable = true;
      # disable after setup
      passwordAuthentication = false;
      # don't permit rootlogin. Only using this for version control only
      permitRootLogin = "no";
    };
    # pretty sure I just need a vc user with version control access
    users.users.vc = {
      isNormalUser = true;
      description = "git user";
      createHome = true;
      home = "/home/vc";
      # shell = "${pkgs.git}/bin/git-shell";
      # just put it locally I guess, I don't want to add keys here
      openssh.authorizedKeys.keys = [# "your public rsa key goes here"
                                    ];
    };
  };
}
