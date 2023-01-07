# TODO allow for my own options I guess - of which version of emacs I want to use.
{ config, lib, pkgs, ... }:
let
  cfg = config.tthome.emacs;
  # copied from the emacs overlay
  libName = drv: lib.removeSuffix "-grammar" drv.pname;
  libSuffix = "so";
  olib = drv: ''lib${libName drv}.${libSuffix}'';
  linkCmd = drv: ''ln -s ${drv}/parser $out/lib/${olib drv}'';
  # this outputs a bunch of grammars files that I can add to emacs loadpath
  plugins = with pkgs.tree-sitter-grammars; [
    tree-sitter-haskell
    tree-sitter-verilog
    tree-sitter-nix
  ];
  # (pkgs.tree-sitter.withPlugins (p: builtins.attrValues p));
  # my-ts-grammars = ()
  tt-tree-sitter-grammars = pkgs.runCommand "tt-tree-sitter-grammars" {}
    (lib.concatStringsSep "\n" (["mkdir -p $out/lib"] ++ (map linkCmd plugins)));
in
{
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
  config = lib.mkIf cfg.enable
    {
      # TODO I need to change this to use emacsng instead.. Just experimenting for now
      services.emacs = {
        enable = true;
        defaultEditor = true;
      };
      programs.emacs =  {
        enable =  true;
        package =
          # pkgs.emacs;
          # try the latest unstable emacs..
          cfg.emacsPkg;
        
        # (pkgs.emacsGit.override { nativeComp = true; }); # For latest emacs git:    
        # prob wanna try the tree-
        # pkgs.; 
      };
      home.packages = with pkgs; [
        tt-tree-sitter-grammars

        # If I want to check email with emacs
        #     mu
        # isync
        # Latex and Minted - install this in home
        # this is 4 GB lol..
        (texlive.combine {
          inherit (texlive)
            beamer
            collection-basic
            collection-fontsextra
            collection-fontsrecommended
            collection-langenglish
            collection-langportuguese
            collection-latex
            collection-latexextra
            collection-mathscience
            enumitem
            fancyhdr
            hyphen-portuguese
            latexmk
            textcase
            scheme-medium
          ;
          # scheme-full minted fancyhdr;
        })
        python38Packages.pygments

      ];
      home.sessionVariables = {
        TS_LIBS = "${tt-tree-sitter-grammars}";
      };
    };
    
}

