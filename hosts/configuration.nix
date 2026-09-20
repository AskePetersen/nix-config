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
        background = "${../dotfiles/hypr/wallpapers/1366123.jpg}";
      })
      # libsForQt5.breeze-grub
      wget
      google-cloud-sdk
      displaylink # DisplayLink driver for docking station
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

    shellAliases = { vim = "nvim"; };
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

  systemd = {
    # `systemctl suspend-then-hibernate` sleeps to RAM first (instant resume) and
    # falls through to hibernate after this long, so an idle laptop stops draining.
    # hypridle suspends at 15min idle, so 10min here puts hibernate at 25min idle.
    sleep.settings.Sleep.HibernateDelaySec = "10min";

    settings.Manager = {
      RebootWatchdogSec = "60";
      RuntimeWatchdogSec = "60";
      WatchdogDevice = "/dev/watchdog1";
    };

    # Battery conservation: cap charging at 80% on every boot, and make the
    # sysfs node wheel-writable so charge_control.sh can toggle 80/100 without
    # sudo. Toggling to 100% lasts until the next reboot, then it's back to 80.
    services.battery-charge-threshold = {
      description = "Cap battery charging at 80%";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "battery-charge-threshold" ''
          f=/sys/class/power_supply/BAT0/charge_control_end_threshold
          if [ -f "$f" ]; then
            echo 80 > "$f"
            chgrp wheel "$f"
            chmod 664 "$f"
          fi
        '';
      };
    };
  };

  time = {
    timeZone = "Europe/Copenhagen";
    hardwareClockInLocalTime = true;
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

  services.pipewire =
    let
      sink = dev: "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__${dev}__sink";
      source = dev: "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__${dev}__source";
      setProps = nodeName: props: {
        matches = [{ "node.name" = nodeName; }];
        actions.update-props = props;
      };
    in
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # ALSA names every node after the chipset, which says nothing useful.
      wireplumber.extraConfig."10-friendly-names" = {
        "monitor.alsa.rules" =
          let
            rename = nodeName: description: setProps nodeName { "node.description" = description; };
          in
          [
            (rename (sink "Speaker") "Laptop Speakers")
            (rename (sink "HDMI1") "External Display 1")
            (rename (sink "HDMI2") "External Display 2")
            (rename (sink "HDMI3") "External Display 3")
            # Mic1 is the DMIC array, Mic2 the analog jack, per the HDA UCM.
            (rename (source "Mic1") "Built-in Microphone")
            (rename (source "Mic2") "Headset Microphone")
          ];
      };

      # Every UCM profile carries the HDMI sinks, so drop them outright.
      wireplumber.extraConfig."20-hide-hdmi-sinks" = {
        "monitor.alsa.rules" = map
          (dev: setProps (sink dev) { "node.disabled" = true; })
          [ "HDMI1" "HDMI2" "HDMI3" ];
      };

      # Defaults by priority alone, with the built-ins below any headset.
      wireplumber.extraConfig."30-builtins-last" = {
        "monitor.alsa.rules" = [
          (setProps (sink "Speaker") { "priority.session" = 900; })
          (setProps (source "Mic1") { "priority.session" = 900; })
        ];
        "wireplumber.settings"."node.restore-default-targets" = false;
      };
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

  system.stateVersion = "24.11"; # Did you read the comment?
}
