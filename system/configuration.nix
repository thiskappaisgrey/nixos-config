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
    settings = {
      # START_CHARGE_THRESH_BAT0=75;
      # STOP_CHARGE_THRESH_BAT0=80;

      CPU_SCALING_GOVERNOR_ON_AC="schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT="schedutil";

      CPU_SCALING_MIN_FREQ_ON_AC=800000;
      CPU_SCALING_MAX_FREQ_ON_AC=3500000;
      CPU_SCALING_MIN_FREQ_ON_BAT=800000;
      CPU_SCALING_MAX_FREQ_ON_BAT=2300000;

      # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
      # A value of 0 disables, >=1 enables power saving (recommended: 1).
      # Default: 0 (AC), 1 (BAT)
      SOUND_POWER_SAVE_ON_AC=0;
      SOUND_POWER_SAVE_ON_BAT=1;

      # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
      # Default: on (AC), auto (BAT)
      RUNTIME_PM_ON_AC="on";
      RUNTIME_PM_ON_BAT="auto";

      # Battery feature drivers: 0=disable, 1=enable
      # Default: 1 (all)
      NATACPI_ENABLE=1;
      TPACPI_ENABLE=1;
      TPSMAPI_ENABLE=1;
    };
  };
  powerManagement.powertop.enable = true;

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
    # KMonad user access to /dev/uinput
    ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput" ''
    ''
      ACTION=="add|change", KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess", RUN{builtin}+="uaccess"''
    ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"''

  ];
  services.udev.packages = [ pkgs.android-udev-rules ];
  services.auto-cpufreq.enable = true; # power saving
  networking.hostName = "thanawat"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Enables wireless support via wpa_supplicant.
  networking.enableIPv6 = false;

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
        executable = let
          # pkgs-old = import  (builtins.fetchGit {
          #   # Descriptive name to make the store path easier to identify
          #   name = "my-old-revision";
          #   url = "https://github.com/NixOS/nixpkgs/";
          #   ref = "refs/heads/nixpkgs-unstable";
          #   rev = "5e15d5da4abb74f0dd76967044735c70e94c5af1";
          # }) { };
          # pkgs-old = import (builtins.fetchTarball {
          #   url =
          #     "https://github.com/NixOS/nixpkgs/archive/9986226d5182c368b7be1db1ab2f7488508b5a87.tar.gz";
          #   sha256 =  "1b2palj1q8q6jdba7qwxgkiz3fab9c57a4jxjn1sar6qifamlgq7";
          # }) { config.allowUnfree = true; };

        in "${lib.getBin pkgs.zoom-us}/bin/zoom-us";
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

    packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [ libxkbcommon mesa wayland zlib libpng ];
      };
    };
  };
  nixpkgs.overlays = [
    (self: super: {
      steam-run = (super.steam.override {
        extraLibraries = pkgs:
          with pkgs; [
            libxkbcommon
            mesa
            wayland
            zlib
            libpng
          ];
      }).run;
      mmorph = self.callHackage "mmorph" "1.1.3" { };
      xmonad = self.xmonad_0_17_0;
      xmonad-contrib = self.xmonad-contrib_0_17_0;
      xmonad-extras = self.xmonad-extras_0_17_0;
    })
  ];
  services.dbus.packages = with pkgs; [ dconf ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.substituters = [
      "https://cache.nixos.org/"
      "https://nixcache.reflex-frp.org"
      "https://hydra.iohk.io"
    ];
    settings.trusted-public-keys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    settings.auto-optimise-store = true;
  };
  hardware.opengl.enable =  true;

  # arbtt - time tracking
  services.arbtt.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    [
      wget
      zip
      unzip
      neovim
      mu
      isync
      brave
      nyxt
      firefox
      alacritty
      fish
      git
      wordnet
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
      pavucontrol
      brightnessctl
      dunst
      libnotify
      steam-run
      # Latex and Minted .. TODO move this over to home-manager
      (texlive.combine {
        # Example of additional packages, probably unnecessary
        inherit (texlive) scheme-full minted fancyhdr;
      })
      python38Packages.pygments

      gnuplot

      hardinfo
      hwinfo
      lshw
      xboxdrv
      glxinfo

      trayer
      linuxPackages.acpi_call
      lm_sensors
      man-pages
      man-pages-posix

      
      
      # xorg.xinit
      # (import ./packages/kmonad.nix)
    ]; # ++ (import ./programs/programming.nix pkgs);
  programs.steam.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };
  # Enable https://github.com/target/lorri for easier nix-shell integration
  services.lorri.enable = true;
  services.fwupd.enable = true;
  services.autorandr.enable = true;
  # services.clight = {
  #   enable = true;
  #   settings = { keyboard = { disabled = true; }; };
  # };
  location.provider = "geoclue2";
  # services.picom = {
  #   enable = true;
  #   fade = true;
  #   inactiveOpacity = 0.9;
  #   shadow = false;
  #   fadeDelta = 4;
  #   vSync = true;
  #   backend = "glx";
  # };

  ## VIRTUALIZATION ##
  ## Virtual Box
  # virtualisation.virtualbox.host.enable = true; #I don't need this right now!
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  ## Libvirtd - QEMU
  # virtualisation.libvirtd.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
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
  # sound.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  #  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
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

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "thanawat";
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  # services.xserver.windowManager.xmonad.extraPackages = hpkgs: [ hpkgs.taffybar ];
  services.xserver.digimend.enable = true;
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock}/bin/i3lock";
  };
  environment.shells = with pkgs; [ bashInteractive fish ];

  services.syncthing = {
    enable = true;
    user = "thanawat";
    dataDir = "/home/thanawat";
    configDir = "/home/thanawat/.config/syncthing";
  };

  # services.fprintd.enable = true;
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
      "jackaudio"
      # "libvirtd"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
  nix.settings.trusted-users = [ "root" "thanawat" ];
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
