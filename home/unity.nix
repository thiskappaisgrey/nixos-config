let
  oldPkgs =
    import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify                
      name = "my-old-revision";                                                 
      url = "https://github.com/NixOS/nixpkgs/";                       
      ref = "refs/heads/nixpkgs-unstable";                     
      rev = "ff8b619cfecb98bb94ae49ca7ceca937923a75fa";                                           
    }) { system = "x86_64-linux";}; 
    # import (builtins.fetchGit {
    #      # Descriptive name to make the store path easier to identify                
    #      name = "my-old-revision";                                                 
    #      url = "https://github.com/NixOS/nixpkgs/";                       
    #      ref = "refs/heads/nixpkgs-unstable";                     
    #      rev = "d1c3fea7ecbed758168787fe4e4a3157e52bc808";                                           
    #  }) { system = "x86_64-linux"; };                                                                           

     my-openssl = oldPkgs.openssl;
in
{ config , pkgs , lib , ... }:
# Desktop environment stuff
{
    # TODO rn, i'm overriding to openssl version 1 b/c of unityhub breaking.. Ideally, I'd want to only override unity stuff
  # nixpkgs.overlays = [ (self: super: { openssl = super.openssl_1_1; } ) ];
  home.packages = with pkgs; [
    # C# stuff
    mono
    omnisharp-roslyn
    dotnet-sdk
    my-openssl
    
    # openssl
    
    # TODO I need openssl from march.. (1.1.1n) https://lazamar.co.uk/nix-versions/?package=openssl&version=1.1.1n&fullName=openssl-1.1.1n&keyName=openssl&revision=d1c3fea7ecbed758168787fe4e4a3157e52bc808&channel=nixpkgs-unstable#instructions
    (pkgs.callPackage  ./unityhub.nix {
      openssl_1_1 = my-openssl;
    })

  ];

}
