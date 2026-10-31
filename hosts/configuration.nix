# Default configuration across all systems
{ config, lib, pkgs, inputs, vars, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      # Create a desktop entry that opens text files in kitty with proper nvim
      nixd # nix lsp
      (pkgs.makeDesktopItem {
        name = "nvim-kitty";
        desktopName = "Neovim (Kitty)";
        exec = "${pkgs.kitty}/bin/kitty -e nvim %F";
        terminal = false;
        icon = "nvim";
        mimeTypes = [ "text/plain" "text/x-python" "text/x-c" "text/html" "text/css" "text/javascript" ];
        categories = [ "Development" "TextEditor" ];
      })
      zapzap # Whatsapp client
      bash-preexec # reliable preexec/precmd hooks, sourced from .bashrc
      usbutils # to do something like lsusb
      mesa # used for some hyprland conf
      libdrm # used for some hyprland conf
      nmap
      gitleaks # scan repos for leaked secrets
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
      gnome-calendar
      qalculate-gtk
      file # Just the findcommand
      catppuccin-cursors.frappeBlue # my neat cursor
      # texliveFull # Den har alt latex. One day when we need it
      bitwarden-desktop # password manager. kæmpe bis
      zathura # vim pdf-viewer
      htop # se kørende processor
      blueman # bluetooth
      networkmanagerapplet # nm-connection-editor, for VPNs/static IPs
      # thunderbird
      # bluez
      # fprintd # fingerscanning
      pavucontrol # sound control
      starship # terminal jizz
      brightnessctl
      swayosd # on-screen volume slider; server is started from hyprland.conf
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
        background = "${../dotfiles/hypr/wallpapers/background.png}";
      })
      # libsForQt5.breeze-grub
      wget
      google-cloud-sdk
      kdePackages.kolourpaint
      jq # jq is a command-line JSON processor, we use it in our monitor script
      kdePackages.merkuro
      qimgv
      wowup-cf # Curseforge for wow
      socat # used for language change notification script
    ];

    # NixOS doesn't link /share/bash into the system profile by default;
    # needed so .bashrc can source bash-preexec.sh from /run/current-system.
    pathsToLink = [ "/share/bash" ];

    sessionVariables = {
      NODE_OPTIONS = "--max-old-space-size=4096";
      XDG_PICTURES_DIR = "$HOME";
      EDITOR = "nvim";
      VISUAL = "nvim";
      # Wayland / Hyprland specific variables
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    shellAliases = {
      vim = "nvim";
      laptop-off = "~/nix-config/dotfiles/startupScripts/monitor-setup.sh external";
      laptop-on = "~/nix-config/dotfiles/startupScripts/monitor-setup.sh";
    };
  };

  # import ../packages
  imports = import ../programs;

  nix = {
    # substitue = true;
    # builders-use-substitutes = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    package = pkgs.nix;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };


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

  # Laptop-only settings (battery, hibernate delay, fingerprint, local-time
  # clock) live in hosts/laptop.nix, imported by thinkpad and ideapad.

  time.timeZone = "Europe/Copenhagen";

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
    pulseaudio.enable = false;
    printing.enable = true;
    # onedrive = {
    # 	enable = true; # Set this to false and uncomment when we want to enable it (maybe)
    # 	monitor = true;
    # };
    displayManager = {
      gdm.enable = false;
      sddm = {
        enable = true;
        theme = "catppuccin-mocha-mauve";
        package = pkgs.kdePackages.sddm;
      };
      sessionPackages = [ pkgs.hyprland ];
      # hyprland 0.55+ ships a uwsm-managed session file too, and SDDM would
      # auto-pick it (sorts first). uwsm isn't enabled here, so its
      # bindpid user unit is missing and the session dies right after login.
      # Pin the plain direct-launch Hyprland session instead.
      defaultSession = "hyprland";
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
  # Remap PrtSc (KEY_SYSRQ) to Super. Done at the evdev level so it applies in
  # Hyprland, TTYs and anything else. Hyprland's kb_options has no option for
  # this key (unlike caps:escape).
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.sysrq = "leftmeta";
    };
  };

  # The wireplumber node renames are keyed on the thinkpad's Intel HDA node
  # names and live in hosts/thinkpad/default.nix.
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
    extraGroups = [ "plugdev" "networkmanager" "wheel" "dialout" ];
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

  nixpkgs = {
    config = {
      # Allow unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-39.8.10"
      ];
    };

    # claude-code is pulled from its own flake input (nixpkgs-claude) so it can be
    # updated on its own: `nix flake update nixpkgs-claude && nixos-rebuild switch`
    overlays = [
      (_final: prev: {
        inherit
          (import inputs.nixpkgs-claude {
            inherit (prev.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          })
          claude-code;
      })
    ];
  };

  # Set as default for text files
  xdg.mime.defaultApplications = {
    "text/plain" = "nvim-kitty.desktop";
  };

  virtualisation.docker.enable = true;

}
