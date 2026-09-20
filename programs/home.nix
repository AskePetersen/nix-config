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
            commit.template = "${config.home.homeDirectory}/.gitmessage";
          };
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
