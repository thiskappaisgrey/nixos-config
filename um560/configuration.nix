# TODO rewrite this stuff
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
# let
#   # pattern to import from library
#   inherit (lib.my) allFileNames;
# in
{
  # tt = allFileNames ../modules;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  services.dbus.packages = with pkgs; [ dconf ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.dconf.enable = true;

  # enable arbtt
  services.arbtt.enable = true;
  services.xserver.digimend.enable = true; # for drawing tablets

  networking.hostName = "thanawat-um560"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
experimental-features = nix-command flakes
'';
    trustedUsers = ["root" "thanawat"];
  };
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # TODO Virtualization (move this to it's own config file)
  virtualisation.libvirtd.enable = true; 
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraGroups.plugdev = { };
  users.users.thanawat = {
     isNormalUser = true;
     extraGroups = [ "wheel"
                     "adbusers"
                     "input"
                     "plugdev"
                     "dialout"
                   ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
   };
  services.udev.extraRules = lib.mkMerge [
    ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"''
    # adafruit tft.. hopefully this works?
    ''
    SUBSYSTEMS=="usb|tty|hidraw", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="810f", MODE="664", GROUP="plugdev" ''

  ];
  nix.settings.trusted-public-keys = [
    # "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" # reflex-frp
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    firefox
    git
    xterm
    lm_sensors
    htop
    # pass
    alacritty
     # (pkgs.tree-sitter.withPlugins (p: builtins.attrValues p))
    jay
    vulkan-tools
   ];
  security.polkit.enable = true;
  # i will probably migrate to bitwarden.
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

  services.udisks2.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

 
}

