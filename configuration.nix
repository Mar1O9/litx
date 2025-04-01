# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "marnix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

services.xserver = {
  enable = true;
  displayManager.gdm.enable = true;
  desktopManager.gnome.enable = true;
};

environment.gnome.excludePackages = (with pkgs; [
  atomix # puzzle game
  cheese # webcam tool
  epiphany # web browser
  evince # document viewer
  geary # email reader
  gedit # text editor
  gnome-characters
  gnome-music
  gnome-photos
  #gnome-terminal
  gnome-tour
  hitori # sudoku game
  iagno # go game
  tali # poker game
  totem # video player
]);

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mar = {
    isNormalUser = true;
    description = "Mar";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      # Storage options
      storageDriver = "overlay2";
      # Extra options for the daemon
      daemon.settings = {
        # Example: Set default logging driver
        "log-driver" = "json-file";
        "log-opts" = {
          "max-size" = "10m";
          "max-file" = "3";
        };
        # Example: Set custom DNS
        "dns" = [ "8.8.8.8" "8.8.4.4" ];
      };
      # Enable rootless mode (optional)
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs ={
    nix-ld = {
        enable = true;
        # Optionally specify additional libraries
        libraries = with pkgs; [
          # Add libraries your application needs here
          stdenv.cc.libc
          zlib
          glib
          openssl
          libGL
          xorg.libX11.dev
          xorg.libXft
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXrandr
          xorg.libXxf86vm
          libxkbcommon
          wayland
          glfw-wayland
          alsa-lib
        ];
    };
    zsh = {
        enable = true;
    };
    firefox = {
        enable = false;
    };
  };

  environment.sessionVariables = {
    # Use `makeLibraryPath` to generate paths for libraries
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      # Add other libraries here
      pkgs.stdenv.cc.cc.lib
      pkgs.stdenv.cc.libc
      pkgs.zlib
      pkgs.glib
      pkgs.openssl
      pkgs.libGL
      pkgs.xorg.libX11.dev
      pkgs.xorg.libXft
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
      pkgs.xorg.libXinerama
      pkgs.xorg.libXrandr
      pkgs.xorg.libXxf86vm
      pkgs.libxkbcommon
      pkgs.wayland
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages."${system}".twilight-official # artifacts are downloaded from the official Zen repository
    inputs.ghostty.packages.x86_64-linux.default
    oh-my-posh
    fastfetch
    vim
    neovim
    python313
    pkg-config
    git
    docker-compose
    wget
    gnome-browser-connector
    deno
    go
    air
    wails
    rustup
    mold
    gnumake
    gcc
    cmake
    llvmPackages_19.llvm
    llvmPackages_19.clang
    llvmPackages_19.clang-tools
    zed-editor
    telegram-desktop
    postman
    vlc

    # libraries

    stdenv.cc.cc.lib
    stdenv.cc.libc
    zlib
    glib
    openssl
    libGL
    xorg.libX11.dev
    xorg.libXft
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    libxkbcommon
    wayland
    glfw-wayland
    alsa-lib
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
