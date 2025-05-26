{config, lib, pkgs, hyprland, vars, host, ... }:
with lib;
with host;
{
  options = {
    hyprland.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (config.hyprland.enable ) {

	# Environment shamelessly stolen from u
    environment =
      let
        exec = "exec dbus-launch Hyprland";
      in
      {
        loginShellInit = ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            ${exec}
          fi
        '';

        variables = {
          # WLR_NO_HARDWARE_CURSORS="1"; # Needed for VM
          # WLR_RENDERER_ALLOW_SOFTWARE="1";
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
          XCURSOR = "Catppuccin-Mocha-Dark-Cursors";
          XCURSOR_SIZE = 24;
          NIXOS_OZONE_WL = 1;
          SDL_VIDEODRIVER = "wayland";
          OZONE_PLATFORM = "wayland";
          WLR_RENDERER_ALLOW_SOFTWARE = 1;
          CLUTTER_BACKEND = "wayland";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_QPA_PLATFORMTHEME = "qt6ct";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          QT_AUTO_SCREEN_SCALE_FACTOR = 1;
          GDK_BACKEND = "wayland";
          WLR_NO_HARDWARE_CURSORS = "1";
          MOZ_ENABLE_WAYLAND = "1";
        };
      };
	  
	  services.greetd = {
		  enable = true;
		  settings = {
			  default_session = {
				  command = "${config.programs.hyprland.package}/bin/Hyprland"; # tuigreet not needed with exec-once hyprlock
				  user = vars.user;
			  };
		  };
		  vt = 7;
	  };
	  systemd.sleep.extraConfig = ''
		  AllowSuspend=yes
		  AllowHibernation=yes
		  AllowSuspendThenHibernate=yes
		  AllowHybridSleep=yes
	  ''; # Clamshell Mode

	  home-manager.users.${vars.user} =
		  let
			lid = if hostName == "xps" then "LID0" else "LID";
			lockScript = pkgs.writeShellScript "lock-script" ''
			  action=$1
			  ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
			  if [ $? == 1 ]; then
				if [ "$action" == "lock" ]; then
				  ${pkgs.hyprlock}/bin/hyprlock
				elif [ "$action" == "suspend" ]; then
				  ${pkgs.systemd}/bin/systemctl suspend
				fi
			  fi
			'';
		  in
		  {
			imports = [
			  hyprland.homeManagerModules.default
			];

			programs.hyprlock = {
			  enable = true;
			  settings = {
				general = {
				  hide_cursor = true;
				  no_fade_in = false;
				  disable_loading_bar = true;
				  grace = 0;
				};
				input-field = [
				  {
					monitor = "";
					size = "250, 60";
					outline_thickness = 2;
					dots_size = 0.2;
					dots_spacing = 0.2;
					dots_center = true;
					outer_color = "rgba(0, 0, 0, 0)";
					inner_color = "rgba(0, 0, 0, 0.5)";
					font_color = "rgb(200, 200, 200)";
					fade_on_empty = false;
					placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
					hide_input = false;
					position = "0, -120";
					halign = "center";
					valign = "center";
				  }
				];
				label = [
				  {
					monitor = "";
					text = "$TIME";
					font_size = 120;
					position = "0, 80";
					valign = "center";
					halign = "center";
				  }
				];
			  };
			};

			services.hypridle = {
			  enable = true;
			  settings = {
				general = {
				  before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
				  after_sleep_cmd = "${config.programs.hyprland.package}/bin/hyprctl dispatch dpms on";
				  ignore_dbus_inhibit = true;
				  lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
				};
				listener = [
				  {
					timeout = 300;
					on-timeout = "${lockScript.outPath} lock";
				  }
				  {
					timeout = 1800;
					on-timeout = "${lockScript.outPath} suspend";
				  }
				];
			  };
			};

			services.hyprpaper = {
			  enable = true;
			  settings = {
				ipc = true;
				splash = false;
				preload = "$HOME/.config/wall.png";
				wallpaper = ",$HOME/.config/wall.png";
			  };
			};

			wayland.windowManager.hyprland = with colors.scheme.default.hex; {
			  enable = true;
			  package = hyprland.packages.${pkgs.system}.hyprland;
			  xwayland.enable = true;
			  # plugins = [
			  #   hyprspace.packages.${pkgs.system}.Hyprspace
			  # ];
			  # # plugin settings
			  # extraConfig = ''
			  #   bind=SUPER,Tab,overview:toggle
			  #   plugin:overview:panelHeight=150
			  #   plugin:overview:drawActiveWorkspace=false
			  #   plugin:overview:gapsIn=3
			  #   plugin:overview:gapsOut=6
			  # '';
			  settings = {
				general = {
				  border_size = 2;
				  gaps_in = 3;
				  gaps_out = 6;
				  "col.active_border" = "0x99${active}";
				  "col.inactive_border" = "0x66${inactive}";
				  resize_on_border = true;
				  hover_icon_on_border = false;
				  layout = "dwindle";
				};
				decoration = {
				  rounding = 6;
				  active_opacity = 1;
				  inactive_opacity = 1;
				  fullscreen_opacity = 1;
				};
				monitor = [
				  ",preferred,auto,1,mirror,${toString mainMonitor}"
				] ++ (if hostName == "beelink" || hostName == "h310m" then [
				  "${toString mainMonitor},1920x1080@60,1920x0,1"
				  "${toString secondMonitor},1920x1080@60,0x0,1"
				] else if hostName == "work" then [
				  "${toString mainMonitor},preferred,0x0,1"
				  "${toString secondMonitorDesc},1920x1200@60,1920x0,1"
				  "${toString thirdMonitorDesc},1920x1200@60,3840x0,1"
				] else if hostName == "xps" then [
				  "${toString mainMonitor},3840x2400@60,0x0,2"
				  "${toString secondMonitor},1920x1080@60,1920x0,1"
				  "${toString thirdMonitor},1920x1080@60,3840x0,1"
				] else [
				  "${toString mainMonitor},1920x1080@60,0x0,1"
				]);
				workspace =
				  if hostName == "beelink" || hostName == "h310m" then [
					"1, monitor:${toString mainMonitor}"
					"2, monitor:${toString mainMonitor}"
					"3, monitor:${toString mainMonitor}"
					"4, monitor:${toString mainMonitor}"
					"5, monitor:${toString secondMonitor}"
					"6, monitor:${toString secondMonitor}"
					"7, monitor:${toString secondMonitor}"
					"8, monitor:${toString secondMonitor}"
				  ] else if hostName == "xps" || hostName == "work" then [
					"1, monitor:${toString mainMonitor}"
					"2, monitor:${toString mainMonitor}"
					"3, monitor:${toString mainMonitor}"
					"4, monitor:${toString secondMonitor}"
					"5, monitor:${toString secondMonitor}"
					"6, monitor:${toString secondMonitor}"
				  ] else [ ];
				animations = {
				  enabled = false;
				  bezier = [
					"overshot, 0.05, 0.9, 0.1, 1.05"
					"smoothOut, 0.5, 0, 0.99, 0.99"
					"smoothIn, 0.5, -0.5, 0.68, 1.5"
					"rotate,0,0,1,1"
				  ];
				  animation = [
					"windows, 1, 4, overshot, slide"
					"windowsIn, 1, 2, smoothOut"
					"windowsOut, 1, 1, smoothOut"
					"windowsMove, 1, 3, smoothIn, slide"
					"border, 1, 5, default"
					"fade, 1, 4, smoothIn"
					"fadeDim, 1, 4, smoothIn"
					"workspaces, 1, 4, default"
					"borderangle, 1, 20, rotate, loop"
				  ];
				};
				input = {
				  kb_layout = "dk";
				  # kb_layout=us,us
				  # kb_variant=,dvorak
				  # kb_options=caps:ctrl_modifier
				  # kb_options = "caps:escape";
				  follow_mouse = 2;
				  repeat_delay = 250;
				  numlock_by_default = 1;
				  accel_profile = "flat";
				  sensitivity = 0.8;
				  natural_scroll = false;
				  touchpad =
					if hostName == "work" || hostName == "xps" || hostName == "probook" then {
					  natural_scroll = true;
					  scroll_factor = 0.2;
					  middle_button_emulation = true;
					  tap-to-click = true;
					} else { };
				};
				device = {
				  name = "epic-mouse-v1";
				  sensitivity = -0.5;
				  natural_scroll = true;
				};
				gestures =
				  if hostName == "laptop" || hostName == "xps" || hostName == "probook" then {
					workspace_swipe = true;
					workspace_swipe_fingers = 3;
					workspace_swipe_distance = 100;
					workspace_swipe_create_new = true;
				  } else { };
				dwindle = {
				  pseudotile = false;
				  force_split = 2;
				  preserve_split = true;
				};
				misc = {
				  disable_hyprland_logo = true;
				  disable_splash_rendering = true;
				  mouse_move_enables_dpms = true;
				  mouse_move_focuses_monitor = true;
				  key_press_enables_dpms = true;
				  background_color = "0x111111";
				};
				ecosystem = {
				  no_update_news = true;
				};
				bindm = [
				  "SUPER,mouse:272,movewindow"
				  "SUPER,mouse:273,resizewindow"
				];
				bind = [
				  "SUPER,Return,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal}"
				  "SUPER,Q,killactive,"
				  "SUPER,M,exit,"
				  "SUPER,S,exec,${pkgs.systemd}/bin/systemctl suspend"
				  "SUPER,L,exec,${pkgs.hyprlock}/bin/hyprlock"
				  # "SUPER,E,exec,GDK_BACKEND=x11 ${pkgs.pcmanfm}/bin/pcmanfm"
				  "SUPER,E,exec,nautilus"
				  "SUPER,F,firefox,"
				  "SUPER,Space,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun"
				  ",F11,fullscreen,"
				  "SUPER,T,exec,${pkgs.${vars.terminal}}/bin/${vars.terminal} -e nvim"
				  "SUPER,j,movefocus,l"
				  "SUPER,k,movefocus,d"
				  "SUPER,l,movefocus,u"
				  "SUPER,ae,movefocus,r"
				  "SUPERSHIFT,j,movewindow,l"
				  "SUPERSHIFT,k,movewindow,d"
				  "SUPERSHIFT,l,movewindow,u"
				  "SUPERSHIFT,ae,movewindow,r"
				  "SUPER,1,workspace,1"
				  "SUPER,2,workspace,2"
				  "SUPER,3,workspace,3"
				  "SUPER,4,workspace,4"
				  "SUPER,5,workspace,5"
				  "SUPER,6,workspace,6"
				  "SUPER,7,workspace,7"
				  "SUPER,8,workspace,8"
				  "SUPER,9,workspace,9"
				  "SUPER,0,workspace,10"
				  "SUPERSHIFT,1,movetoworkspace,1"
				  "SUPERSHIFT,2,movetoworkspace,2"
				  "SUPERSHIFT,3,movetoworkspace,3"
				  "SUPERSHIFT,4,movetoworkspace,4"
				  "SUPERSHIFT,5,movetoworkspace,5"
				  "SUPERSHIFT,6,movetoworkspace,6"
				  "SUPERSHIFT,7,movetoworkspace,7"
				  "SUPERSHIFT,8,movetoworkspace,8"
				  "SUPERSHIFT,9,movetoworkspace,9"
				  "SUPERSHIFT,0,movetoworkspace,10"

				  "SUPER,Z,layoutmsg,togglesplit"
				  ",print,exec,${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png"
				];
				bindel = [
				  ",XF86AudioRaiseVolume,exec,wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
				  ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				  ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				  ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				  ",XF86MonBrightnessDown,exec,brightnessctl s 10%+"
				  ",XF86MonBrightnessUP,exec,brightnessctl s 10%-"
				];
				#binde = [
				#  "SUPERCTRL,right,resizeactive,60 0"
				#  "SUPERCTRL,left,resizeactive,-60 0"
				#  "SUPERCTRL,up,resizeactive,0 -60"
				#  "SUPERCTRL,down,resizeactive,0 60"
				# ];
				#bindl =
				#  if hostName == "xps" || hostName == "work" then [
			#		",switch:Lid Switch,exec,$HOME/.config/hypr/script/clamshell.sh"
		#		  ] else [ ];
				windowrulev2 = [
				  "float,title:^(Volume Control)$"
				  "keepaspectratio,class:^(firefox)$,title:^(Picture-in-Picture)$"
				  "noborder,class:^(firefox)$,title:^(Picture-in-Picture)$"
				  "float, title:^(Picture-in-Picture)$"
				  "size 24% 24%, title:(Picture-in-Picture)"
				  "move 75% 75%, title:(Picture-in-Picture)"
				  "pin, title:^(Picture-in-Picture)$"
				  "float, title:^(Firefox)$"
				  "size 24% 24%, title:(Firefox)"
				  "move 74% 74%, title:(Firefox)"
				  "pin, title:^(Firefox)$"
				  "opacity 0.9, class:^(kitty)"
				  "tile,initialTitle:^WPS.*"
				];
				exec-once = [
				  "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
				  "${pkgs.hyprlock}/bin/hyprlock"
				  "ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr"
				  "${pkgs.waybar}/bin/waybar -c $HOME/.config/waybar/config"
				  "${pkgs.eww}/bin/eww daemon"
				  # "$HOME/.config/eww/scripts/eww" # When running eww as a bar
				  "${pkgs.blueman}/bin/blueman-applet"
				  "${pkgs.swaynotificationcenter}/bin/swaync"
				  # "${pkgs.hyprpaper}/bin/hyprpaper"
				  "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
				  "${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive --vfs-cache-mode=writes"
				  # "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /GDrive"
				  "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
				];
			  };
			};

			home.file = {
			  ".config/hypr/script/clamshell.sh" = {
				text = ''
				  #!/bin/sh

				  if grep open /proc/acpi/button/lid/${lid}/state; then
					${config.programs.hyprland.package}/bin/hyprctl keyword monitor "${toString mainMonitor}, 1920x1080, 0x0, 1"
				  else
					if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
					  ${config.programs.hyprland.package}/bin/hyprctl keyword monitor "${toString mainMonitor}, disable"
					else
					  ${pkgs.hyprlock}/bin/hyprlock
					  ${pkgs.systemd}/bin/systemctl suspend
					fi
				  fi
				'';
				executable = true;
			  };
			};
		  };
		};
}
