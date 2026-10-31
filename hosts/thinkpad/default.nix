{ config, lib, system, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../laptop.nix
  ];

  # Hibernation: the kernel needs to know which swap holds the image on resume.
  # Without this, hibernating writes the image but boots cold and loses the session.
  boot.resumeDevice = "/dev/disk/by-uuid/9040d67e-bfdb-43f4-ac81-88a58b182cfe"; # nvme0n1p3, 8.8G swap

  # Resume works here, so hibernate at critical battery instead of powering off.
  services.upower.criticalPowerAction = "Hibernate";

  # Android development lives on this machine only
  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk"; # for running android studio
    CAPACITOR_ANDROID_STUDIO_PATH = "/run/current-system/sw/bin/android-studio";
  };

  # hardware.graphics = {
  #   extraPackages = with pkgs; [
  #     intel-media-driver
  #   ];
  # };
  #

  services = {
    xserver = {
      enable = true;
      # DisplayLink support for the docking station; displaylink must come first
      videoDrivers = [ "displaylink" "modesetting" ];
    };

    # ALSA names every node after the chipset, which says nothing useful. These
    # node names are this laptop's Intel HDA, so the rules match nothing elsewhere.
    pipewire.wireplumber.extraConfig =
      let
        sink = dev: "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__${dev}__sink";
        source = dev: "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__${dev}__source";
        setProps = nodeName: props: {
          matches = [{ "node.name" = nodeName; }];
          actions.update-props = props;
        };
        rename = nodeName: description: setProps nodeName { "node.description" = description; };
      in
      {
        "10-friendly-names" = {
          "monitor.alsa.rules" = [
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
        "20-hide-hdmi-sinks" = {
          "monitor.alsa.rules" = map
            (dev: setProps (sink dev) { "node.disabled" = true; })
            [ "HDMI1" "HDMI2" "HDMI3" ];
        };

        # Defaults by priority alone, with the built-ins below any headset.
        "30-builtins-last" = {
          "monitor.alsa.rules" = [
            (setProps (sink "Speaker") { "priority.session" = 900; })
            (setProps (source "Mic1") { "priority.session" = 900; })
          ];
          "wireplumber.settings"."node.restore-default-targets" = false;
        };
      };
  };

  environment.systemPackages = with pkgs; [
    displaylink # DisplayLink driver for docking station
    claude-code
    ast-grep # structural code search/rewrite (`sg`)
    gh # GitHub CLI
    openssl
    postman
    sshfs # Litteraly best tool ever for remote editing
    google-chrome
    dbeaver-bin
    glow # Used for reading markdown files
    mysql84 # used for dbeaver 
    pylint
    python313
    nixpkgs-fmt
    black
    isort
    eslint
    nest-cli
    nodejs_22
    localtunnel
    intelephense
    prettier
    typescript
    typescript-language-server
    #GAMING
    steam
    discord
    # lutris
    # protonplus
    # protonup-rs
    android-studio
    jdk17
  ];
  # hyprland.enable = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
