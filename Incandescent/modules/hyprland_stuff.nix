# Bunch of hyprland related things
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    hyprmisc.enable = lib.mkEnableOption "Enables hyprland related miscellanea";
  };
  config = lib.mkIf config.hyprmisc.enable {
    # Enable Hyprland
    programs.hyprland.enable = true;

    # Enable gvfs for Thunar
    services.gvfs.enable = true;
    # tumbler for Thunar
    services.tumbler.enable = true;
    # Enable Thunar
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };

    # Programs I use with Hyprland
    environment.systemPackages = with pkgs; [
      hyprlock
      hypridle
      hyprpaper
      hyprpicker
      hyprcursor
      grimblast
      waybar
      copyq
      qt6ct
      nwg-look
      pavucontrol
      networkmanagerapplet
      overskride
      font-awesome
      adwaita-icon-theme
      # kdePackages.qtstyleplugin-kvantum
      dconf-editor
      playerctl
      anyrun
      fuzzel
      mako
      hyprlandPlugins.hyprexpo # Hyprland plugins, requires some funny business
      file-roller # For Thunar, but works by itself too
      swayimg
      nomacs
      ripdrag
      gwenview
      # Dolphin stuff
      # kdePackages.dolphin
      # kdePackages.qtwayland
      # kdePackages.qtsvg
      # kdePackages.breeze-icons
      # kdePackages.kservice
      # kdePackages.ark
    ];

    # Hypothetically speaking, symlinks the plugins to /etc/hyprplugins/lib/
    environment.etc."hyprplugins/libhyprexpo".source = "${pkgs.hyprlandPlugins.hyprexpo}/lib/libhyprexpo.so";
  };
}
