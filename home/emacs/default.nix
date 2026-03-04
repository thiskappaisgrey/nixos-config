# TODO allow for my own options I guess - of which version of emacs I want to use.
{ config, lib, pkgs, ... }:
let cfg = config.tthome.emacs;
in {
  options = {
    tthome.emacs = {
      enable = lib.mkEnableOption "Enable my emacs config";
      emacsPkg = lib.mkOption {
        type = lib.types.package;
        default = pkgs.emacs;
        defaultText = lib.literalExpression "pkgs.emacs";
        description = "The Emacs package to install.";
      };

    };
  };
  # make this into a config b/c emacs is pretty heavy
  config = lib.mkIf cfg.enable {
    # TODO I need to change this to use emacsng instead.. Just experimenting for now
    services.emacs = {
      enable = false;
      defaultEditor = true;
    };
    programs.emacs = {
      enable = true;
      package =
        # pkgs.emacs;
        # try the latest unstable emacs..
        cfg.emacsPkg;

      extraPackages =
        (epkgs: (with epkgs; [ treesit-grammars.with-all-grammars ]));
      # (pkgs.emacsGit.override { nativeComp = true; }); # For latest emacs git:    
      # prob wanna try the tree-
      # pkgs.; 
    };
    home.packages = with pkgs; [
      typst
      # typst-lsp
      # typst-fmt
      # typst-live

      emacs-all-the-icons-fonts

    ];

    # home.sessionVariables = {
    # };
  };

}

