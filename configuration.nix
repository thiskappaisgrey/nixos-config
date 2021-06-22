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
  services.upower.enable = true;
  # services.tlp.enable = true;
  services.tlp = {
      enable = true;
    };

  services.udev.extraRules = lib.mkMerge [
    # autosuspend USB devices
    ''ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"''
    # autosuspend PCI devices
    ''ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"''
    # disable Ethernet Wake-on-LAN
    ''ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"''
    # KMonad user access to /dev/uinput
    ''KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput" ''
  ];

  services.auto-cpufreq.enable = true; # power saving
  networking.hostName = "thanawat"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  programs.adb.enable = true;

  programs.slock.enable = true;
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      zoom = {
        executable = "${lib.getBin pkgs.zoom-us}/bin/zoom-us";
        profile = "${pkgs.firejail}/etc/firejail/zoom.profile";
      };
    };
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;

    # Create an alias for the unstable channel

    # packageOverrides = pkgs: {
    # unstable = import <nixos-unstable> { # pass the nixpkgs config to the unstable alias # to ensure `allowUnfree = true;` is propagated:
    # config = config.nixpkgs.config;
    # };
    # };
  };
  nixpkgs.overlays = [
    (import (builtins.fetchTarball
      "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))

    (self: super: {
      steam-run = (super.steam.override {
        extraLibraries = pkgs: with pkgs; [ libxkbcommon mesa wayland zlib ];
      }).run;
      mmorph = self.callHackage "mmorph" "1.1.3" { };
    })
  ];
  nix.binaryCaches =
    [ "https://cache.nixos.org/" "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys =
    [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

  # arbtt - time tracking
  services.arbtt.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    zip
    unzip
    neovim
    mu
    isync
    nixfmt
    brave
    nyxt
    firefox
    alacritty
    # Emacs and related programs
    emacsUnstable
    fish
    git
    syncthing
    syncthing-cli
    sqlite
    wordnet
    ripgrep
    fd
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    gnutls

    direnv
    xmobar
    pass
    gnupg
    mpv
    htop
    powertop
    pulsemixer
    brightnessctl
    dunst
    libnotify
    lutris
    gnome3.adwaita-icon-theme
    cmake
    haskellPackages.arbtt
    spotify
    #diskonaut
    steam-run
    # Latex and Minted
    (texlive.combine {
      # Example of additional packages, probably unnecessary
      inherit (texlive) scheme-full minted;
    })
    python38Packages.pygments
    caffeine-ng

    playerctl
    #shortwave

    gnuplot

    hardinfo
    hwinfo
    lshw

    trayer
    linuxPackages.acpi_call

    graphviz
    tldr

    # For typescript language server
    nodePackages.typescript-language-server
    nodePackages.typescript

    freetube
    anki
    lm_sensors
    (import ./packages/kmonad.nix)
  ] ++ (import ./programs/programming.nix  pkgs);
  programs.steam.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };
  # Enable https://github.com/target/lorri for easier nix-shell integration
  services.lorri.enable = true;
  services.fwupd.enable = true;
  services.clight = {
    enable = true;
    settings = {
      keyboard = {
        disabled = true;
      };
    };
  };
 location.provider = "geoclue2";
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = false;
    fadeDelta = 4;
    vSync = true;
    backend = "glx";
  };

  ## VIRTUALIZATION ##
  ## Virtual Box
  # virtualisation.virtualbox.host.enable = true; I don't need this right now!
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  ## Libvirtd - QEMU
  virtualisation.libvirtd.enable = true;
  # users.extraGroups.vboxusers.members = [ "thanawat" ];

  # flathub(for flatpacks)
  #services.flatpak.enable = true;
  xdg.portal.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,th";
  services.xserver.xkbOptions = "grp:ctrls_toggle,ctrl:nocaps";
  services.xserver.extraLayouts = {
    workman = {
    description = "The workman layout";
    languages = [ "eng" ];
    symbolsFile = ./xorg/workman;
    };
  };


  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "thanawat";
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  services.syncthing = {
    enable = true;
    user = "thanawat";
    dataDir = "/home/thanawat";
    configDir = "/home/thanawat/.config/syncthing";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
  nix.trustedUsers = [ "root" "thanawat" ];
  # Auto Upgrades
  system.autoUpgrade = {
    enable = false; # Don't enable this for now b/c it bit me too many times!!
    dates = "2:00"; # Gotta figure out what times I could do this
    allowReboot = false;
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
