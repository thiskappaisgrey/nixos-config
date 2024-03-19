{ config, pkgs, lib, ... }:
let cfg = config.tthome.dev-tools;
in {
  options = {
    tthome.dev-tools = {
      enable = lib.mkEnableOption "Enable Developer Tools";
      # TODO: Make enable options for each lang

      # nix-enable = 
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [

      (python3.withPackages (ps: with ps; [ pygments epc orjson sexpdata six ]))
      python3Packages.pip

      gcc

      helix

      # janet and other stuff
      nil
      # julia

      janet
      jpm
      lua
      lua-language-server

      nodePackages.pyright

      zellij

      neovide

      nix-init

      nixfmt
      gitui
      lazygit
      ast-grep

      bat
      httpie
      xh
      curlie

      julia-bin
      codebraid

      # llama-cpp
      ollama

      # ocaml-ng.ocamlPackages_5_0.ocaml
      # dune_3
      koka

      foot

      lapce
      go
      gopls

    ];

    home.file = {
      zellij.source = config.lib.file.mkOutOfStoreSymlink
        "/home/thanawat/.dotfiles/home/impure/zellij/";
      zellij.target = "/home/thanawat/.config/zellij";
    };

  };

}
