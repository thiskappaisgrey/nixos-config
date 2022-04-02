{ config, lib, pkgs, ... }:
let
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacsGcc;
    config = ./init.el;
    alwaysEnsure = true;
    alwaysTangle = true;
  };
in
{
  programs.emacs =  {
    enable =  true;
    package = myEmacs;
  };
}
