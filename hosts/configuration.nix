# Default configuration across all systems
{ config, lib, pkgs, stable, inputs, vars, ... }:

{
  imports = (
    import ../programs
    # import ../packages
  );

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.nix;


  security.sudo.wheelNeedsPassword = false; # Bad practice, I'm just tired of typing root pwd

  networking = {
    hostName = "aske";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    networkmanager = {
      enable = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
    };
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        enable = true;
        devices = [ "nodev" ];
        configurationLimit = 10;
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
        theme = pkgs.catppuccin-grub;
      };
    };
  };

  time = {
    timeZone = "Europe/Copenhagen";
    hardwareClockInLocalTime = true;
  };

  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk"; # for running android studio
    NODE_OPTIONS = "--max-old-space-size=4096";
    XDG_PICTURES_DIR = "$HOME";
    CAPACITOR_ANDROID_STUDIO_PATH = "/run/current-system/sw/bin/android-studio";
    EDITOR = "nvim";
    VISUAL = "nvim";
    # Wayland / Hyprland specific variables
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  systemd.settings.Manager = {
    RebootWatchdogSec = "60";
    RuntimeWatchdogSec = "60";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # Enable the X11 windowing system.
  services = {
    gvfs.enable = true;
    udisks2.enable = true; # used for USB devices
    blueman.enable = true;
    fprintd.enable = true;
    pulseaudio.enable = false;
    printing.enable = true;
    # DisplayLink support for docking station
    xserver.videoDrivers = [ "displaylink" "modesetting" ];
    # onedrive = {
    # 	enable = true; # Set this to false and uncomment when we want to enable it (maybe)
    # 	monitor = true;
    # };
    displayManager = {
      gdm.enable = false;
      sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
      };
      sessionPackages = [ pkgs.hyprland ];
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk-latin1";
  };

  # Enable sound with pipewire.
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aske = {
    isNormalUser = true;
    extraGroups = [ "plugdev" "networkmanager" "wheel" ];
    # packages = with pkgs; [
    #  thunderbird
    # ];
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "24.11";
    };
    programs = {
      home-manager.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.caskaydia-cove
    # font-awesome # Icons
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.shellAliases = { vim = "nvim"; };


  # Set as default for text files
  xdg.mime.defaultApplications = {
    "text/plain" = "nvim-kitty.desktop";
  };

  nix = {
    # substitue = true;
    # builders-use-substitutes = true;
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };



  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    # Create a desktop entry that opens text files in kitty with proper nvim
    (pkgs.makeDesktopItem {
      name = "nvim-kitty";
      desktopName = "Neovim (Kitty)";
      exec = "${pkgs.kitty}/bin/kitty -e nvim %F";
      terminal = false;
      icon = "nvim";
      mimeTypes = [ "text/plain" "text/x-python" "text/x-c" "text/html" "text/css" "text/javascript" ];
      categories = [ "Development" "TextEditor" ];
    })
    mesa # used for some hyprland conf
    libdrm # used for some hyprland conf
    nmap
    # google-chrome
    # tmux
    # python313
    # cutter
    #   (python313.withPackages (ps: with ps; [
    # 	pwntools
    # 	capstone
    # 	keystone-engine
    # 	unicorn
    #   ]))
    feh # Image viewer
    slack
    qalculate-qt
    file # Just the findcommand
    catppuccin-cursors.frappeBlue # my neat cursor
    # texliveFull # Den har alt latex. One day when we need it
    bitwarden-desktop # password manager. kæmpe bis
    zathura # vim pdf-viewer
    htop # se kørende processor
    blueman # bluetooth
    # thunderbird
    # bluez
    # fprintd # fingerscanning
    pavucontrol # sound control
    starship # terminal jizz
    brightnessctl
    # grimblast # Screenshot
    # hyprcursor # Cursor
    hypridle
    # hyprland
    hyprpaper # Wallpaper
    hyprshot
    kitty
    libnotify
    # libreoffice
    nautilus
    gvfs # USB drives
    gnome-disk-utility # USB drives
    nwg-look # change the look of hyprland?
    swaynotificationcenter
    waybar
    wl-clipboard # Clipboard
    wlr-randr # Monitor Settings
    wofi
    # xdg-desktop-portal-hyprland
    xwayland # X session
    hyprlock
    # discord
    git
    grub2
    catppuccin-grub
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "JetBrainsMono Nerd Font";
      fontSize = "16";
      background = "${../dotfiles/hypr/wallpapers/1366123.jpg}";
    })
    # libsForQt5.breeze-grub
    wget
    google-cloud-sdk
    displaylink # DisplayLink driver for docking station
    kdePackages.kolourpaint
  ];


  system.stateVersion = "24.11"; # Did you read the comment?
}
