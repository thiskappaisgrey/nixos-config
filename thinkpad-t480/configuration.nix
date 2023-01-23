# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
with lib; {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];


  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  
  # LAPTOP POWER
  services.upower.enable = true;
  # services.tlp.enable = true;
  # autocpu - more power saving stuff
  services.auto-cpufreq.enable = true; # power saving

  services.tlp = {
    enable = true;
    settings = {
      # START_CHARGE_THRESH_BAT0=75;
      # STOP_CHARGE_THRESH_BAT0=80;

      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

      CPU_SCALING_MIN_FREQ_ON_AC = 800000;
      CPU_SCALING_MAX_FREQ_ON_AC = 3500000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 2300000;

      # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
      # A value of 0 disables, >=1 enables power saving (recommended: 1).
      # Default: 0 (AC), 1 (BAT)
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
      # Default: on (AC), auto (BAT)
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # Battery feature drivers: 0=disable, 1=enable
      # Default: 1 (all)
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
    };
  };
  powerManagement.powertop.enable = true;

  # All the udev stuff for laptop power
  services.udev.extraRules = lib.mkMerge [
    # autosuspend USB devices
    ''
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"''
    # autosuspend PCI devices
    ''
      ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"''
    # disable Ethernet Wake-on-LAN
    ''
      ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"''
    
    # not sure what is is.. I should have commented
    # ''
    #   ACTION=="add|change", KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess", RUN{builtin}+="uaccess"''

    # this is for qmk
    ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"''

  ];
  # this is 
  # services.udev.packages = [ pkgs.openocd ];

  

  # Wireless  
  networking.hostName = "thanawat-thinkpad"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Enables wireless support via wpa_supplicant.


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  programs.dconf.enable = true;  
  services.dbus.packages = with pkgs; [ dconf ];
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.substituters = [
      "https://cache.nixos.org/"
      # "https://nixcache.reflex-frp.org"
      # "https://hydra.iohk.io"
    ];
    settings.trusted-public-keys = [
      # "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" # reflex-frp
      # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    settings.auto-optimise-store = true;
  };


  
  # OTHER STUFF
  hardware.opengl.enable = true;
  # arbtt - time tracking
  services.arbtt.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # TODO Move this into a module, default packages???
  environment.systemPackages = with pkgs; [
    wget
    neovim
    firefox
    man-pages
    man-pages-posix
    # just in case config breaks in xmonad - I can still access terminal emulator
    xterm
    # terminal emulator of choice
    alacritty
    git
    htop
    
    # hardinfo utilities
    hardinfo
    hwinfo
    lshw

    
    # glxinfo


  ]; # ++ (import ./programs/programming.nix pkgs);

  # move this to a module too?
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };
  
  services.fwupd.enable = true;

  ## VIRTUALIZATION ##
  ## Virtual Box
  # virtualisation.virtualbox.host.enable = true; #I don't need this right now!
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  ## Libvirtd - QEMU
  # virtualisation.libvirtd.enable = true;
  # TODO try docker rootless first for security reasons.
  # virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  

  # rtkit is optional but recommended
  security.rtkit.enable = true;

  
  # enable flatpak for certain apps that don't work 
  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,th";
  # services.xserver.xkbVariant = "norman";
  services.xserver.xkbOptions = "grp:ctrls_toggle,ctrl:nocaps";
  # services.xserver.extraLayouts = {
  #   halmak = {
  #     description = "The halmak layout";
  #     languages = [ "eng" ];
  #     symbolsFile = ./keyboard-layouts/halmak;
  #   };
  #   engram = {
  #     description = "The Engram layout";
  #     languages = [ "eng" ];
  #     symbolsFile = ./keyboard-layouts/engram;
  #   };
  # };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;



  
  # The taffybar haskellpackage  is broken in nixpkgs so I just copied-paste the file I needed instead
  # services.xserver.windowManager.xmonad.extraPackages = hpkgs: [ jpkgs.taffybar ];

  services.xserver.digimend.enable = true; # for drawing tablets

  environment.shells = with pkgs; [ bashInteractive ];


  services.fprintd.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraGroups.plugdev = { };
  users.users.thanawat = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "adbusers"
      "lp"
      "scannner"
      "input"
      "uinput"
      "jackaudio"
      "plugdev"
      "dialout"
      "docker"
      # "libvirtd"
    ]; # Enable ‘sudo’ for the user.
    # shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ "root" "thanawat" ];
  
  services.udisks2.enable = true;
  
  # make hosts file editable by root
  environment.etc.hosts.mode = "0644";


  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
