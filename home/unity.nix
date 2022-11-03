{ config , pkgs , lib , ... }:
# Desktop environment stuff
{
    # TODO rn, i'm overriding to openssl version 1 b/c of unityhub breaking.. Ideally, I'd want to only override unity stuff
  # nixpkgs.overlays = [ (self: super: { openssl = super.openssl_1_1; } ) ];
  home.packages = with pkgs; [
    # C# stuff
    # mono
    omnisharp-roslyn
    # dotnet-sdk
    
    # openssl
    
    (pkgs.callPackage  ./unityhub.nix {
      openssl = openssl_1_1;
    })

  ];

}
