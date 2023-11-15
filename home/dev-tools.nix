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

      gcc

      helix

      # janet and other stuff
      nil
      julia

      janet
      jpm
      lua
      lua-language-server

      nodePackages.pyright

      zellij

      neovide

      nix-init
    ];

  };

}
