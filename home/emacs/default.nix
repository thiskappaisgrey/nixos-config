{ config, lib, pkgs, ... }:
/*let
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacsGcc;
    config = ./config.org;
    alwaysEnsure = true;
    alwaysTangle = true;

    override = epkgs: epkgs // {
    	restart-emacs = epkgs.melpaPackages.restart-emacs.overrideAttrs(old: {
          patches = [ ./restart-emacs.patch ];
        });
    };
  };
in*/
{
  programs.emacs =  {
    enable =  true;
    package =
      # pkgs.emacs;
     # (pkgs.emacsGit.override { nativeComp = true; }); # For latest emacs git:    
      pkgs.emacsNativeComp; 
  };
}
