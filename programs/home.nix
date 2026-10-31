{ config, lib, pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = { config, ... }:
    let
      # Live symlinks straight into the repo: edits to dotfiles apply
      # immediately, no rebuild needed. Placement stays declarative.
      dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
      link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

      # GTK apps (blueman-manager, pavucontrol, nm-connection-editor, nautilus)
      # ship no theme of their own and fall back to stock Adwaita, which clashes
      # with the mocha bar. Mauve accent matches the sddm theme.
      gtkTheme = "catppuccin-mocha-mauve-standard";
      gtkThemePkg = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
        size = "standard";
      };
    in
    {
      home.file = {
        ".config/kitty".source = link "kitty";
        ".config/waybar".source = link "waybar";
        ".config/hypr".source = link "hypr";
        ".config/wofi".source = link "wofi";
        ".tmux.conf".source = link "tmux/tmux.conf";
        ".bashrc".source = link "bash/.bashrc";
        ".gitmessage".source = link "git/.gitmessage";
        ".config/starship.toml".source = link "starship/starship.toml";
        ".config/htop/htoprc".source = link "htop/htoprc";
        ".config/qimgv/qimgv.conf".source = link "qimgv/qimgv.conf";
        ".config/qimgv/theme.conf".source = link "qimgv/theme.conf";
        ".claude/settings.json".source = link "claude/settings.json";
        ".claude/statusline-command.sh".source = link "claude/statusline-command.sh";
        ".claude/CLAUDE.md".source = link "claude/CLAUDE.md";

        # Sourced at the end of tmux.conf. Plugins from nixpkgs instead of tpm,
        # so every machine has them without a manual git clone.
        ".config/tmux/plugins.conf".text = ''
          run-shell ${pkgs.tmuxPlugins.resurrect.rtp}
          run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator.rtp}
        '';
      };

      # Overrides the matching entries of the system-wide
      # xdg.mime.defaultApplications in hosts/configuration.nix.
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "google-chrome.desktop";
          "x-scheme-handler/http" = "google-chrome.desktop";
          "x-scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/about" = "google-chrome.desktop";
          "x-scheme-handler/unknown" = "google-chrome.desktop";
          "x-scheme-handler/webcal" = "google-chrome.desktop";
          "x-scheme-handler/mailto" = "thunderbird.desktop";
          "message/rfc822" = "thunderbird.desktop";
          "x-scheme-handler/mid" = "thunderbird.desktop";
          "text/calendar" = "thunderbird.desktop";
          "application/x-extension-ics" = "thunderbird.desktop";
          "x-scheme-handler/webcals" = "thunderbird.desktop";
          "x-scheme-handler/postman" = "postman.desktop";
          "image/png" = "qimgv.desktop";
          "image/jpeg" = "qimgv.desktop";
          # Desktop file is written by Claude Code itself on first run.
          "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
          "x-scheme-handler/slack" = "slack.desktop";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = gtkTheme;
          package = gtkThemePkg;
        };
        # gtk4.theme only inherits gtk.theme below stateVersion 26.05; setting it
        # explicitly keeps libadwaita apps themed once we cross that.
        gtk4.theme = {
          name = gtkTheme;
          package = gtkThemePkg;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "mauve";
          };
        };
        cursorTheme = {
          name = "catppuccin-frappe-blue-cursors";
          package = pkgs.catppuccin-cursors.frappeBlue;
          size = 24;
        };
        # libadwaita apps ignore the GTK theme; this is the only knob they read.
        colorScheme = "dark";
        # home-manager writes `gtk-interface-color-scheme=2` for dark, but GTK's
        # key-file parser wants the enum nick, not the integer - gtk 4.22 rejects
        # it with "value that cannot be interpreted" and drops the whole file.
        # extraConfig is merged last, so this overrides it with a value GTK takes.
        gtk4.extraConfig."gtk-interface-color-scheme" = "dark";
      };

      programs = {
        git = {
          enable = true;
          settings = {
            user = {
              name = "aske";
              email = "aske98@live.com";
            };
            commit.template = "${config.home.homeDirectory}/.gitmessage";
          };
          ignores = [ "**/.claude/settings.local.json" ];
        };
        lazygit = {
          enable = true;
          settings = {
            git.commit.signOff = false;
            os.editPreset = " nvim ";
          };
        };
      };
    };
}
