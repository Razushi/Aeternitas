{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  home.username = "razushi";
  home.homeDirectory = "/home/razushi";

  imports = [ ];

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    davinci-resolve
    vlc
    pika-backup
    anytype
    android-tools
    # ardour
    # lsp-plugins
  ];

  # gtk.enable = true;
  #
  # gtk.cursorTheme.package = pkgs.bibata-cursors;
  # gtk.cursorTheme.name = "Bibata-Modern-Classic";
  #
  # gtk.theme.package = pkgs.adw-gtk3;
  # gtk.theme.name = "adw-gtk3-dark";
  #
  #
  # home.pointerCursor = {
  #   gtk.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Classic";
  #   size = 16;
  # };

  # The bababooey number
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  systemd.user.services.hyprland = {
    Unit = {
     Description = "Hyprland Wayland Compositor";
     After = [ "dbus.service" ];
      Wants = [ "dbus.service" ];
    };
    Service = {     
      ExecStart = "/run/current-system/sw/bin/Hyprland";
      Restart = "on-failure";
      Environment = [
        "XDG_SESSION_TYPE=wayland"
        "XDG_CURRENT_DESKTOP=hyprland"
        "XDG_SESSION_DESKTOP=hyprland"
        "XDG_RUNTIME_DIR=/run/user/%U"
        "LIBSEAT_BACKEND=logind"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };


  home.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
    XDG_SESSION_TYPE = "wayland";
  };
}
