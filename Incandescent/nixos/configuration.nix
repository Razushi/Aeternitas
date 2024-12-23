{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Why didn't I set this sooner
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Incandescent"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable fstrim, really should be enabled by default.
  services.fstrim.enable = true;

  # Controls RGB
  services.hardware.openrgb.enable = true;

  # Enable configs for desktop RTX3060
  desktop3060.enable = false;

  # Hyprland config extra
  hyprmisc.enable = true;
  
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
  };

  # Enable bluetooth support
  hardware.bluetooth.enable = true;

  # Explicit firmware packages (Can't be too sure...)
  boot.extraModulePackages = [ pkgs.linux-firmware ];

  # Redistributable firmware for AMD GPU and CPU
  hardware.enableRedistributableFirmware = true;

  # OpenGL and Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # DriSupport
    extraPackages = with pkgs; [
      pkgs.mesa.drivers # 64-Bit 
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      pkgs.pkgsi686Linux.mesa # 32-Bit
    ];
  };
  
  # Docker, nuff said
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_25;

  # Not needed for AMD GPU's)
  # hardware.nvidia-container-toolkit.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #  nix.settings = {
  #    substituters = [
  #      "https://cuda-maintainers.cachix.org"
  #    ];
  #    trusted-public-keys = [
  #      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
  #    ];
  #  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.razushi = {
    isNormalUser = true;
    description = "Razushi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  # Technically redundant, already in flakes.nix, is needed.  
  nixpkgs.config.allowUnfree = true;

  # Unleash the CUDA
  # nixpkgs.config.cudaSupport = true;

  # Enables Scythe's unfree list
  # scythesUnfree.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    # firefox
    appimage-run # Tool for running appimages in NixOS
    clang # C compiler
    gcc # GNU Compiler Collection
    gnome-tweaks
    gnumake
    kdePackages.kcolorpicker
    kdePackages.qtimageformats # Webp previews
    kitty # They put so much money into it, unfortunately made it better
    nixfmt-rfc-style # Formatter for Nix
    wl-clipboard # For terminal copy / paste # Switch to wl-clipboard-rs one day?
    xclip # Needed to copy to clipboard in terminal apps
    # xdg-desktop-portal-gtk # Needed for cursor in some flatpak gtk Apps
    xdg-desktop-portal-hyprland

    # From the moment I understood the weakness of the GUI...
    btop # Neat system monitor
    du-dust # Dust, a rust-written du replacement
    eza # Rust-based ls alternative
    fastfetch # Neofetch but written in C and maintained
    fd # Rust alternative to the find command
    fzf # Great CLI fuzzy finder in Go
    git
    glow # Command line Markdown viewer
    helix
    imagemagick
    neovim # The new classic.
    ripgrep # Rust-based recursive line search tool
    smartmontools # Disk health monitoring stuff
    starship # Terminal prompt written in Rust
    tldr # Community-made, minimal man pages
    wget
    yt-dlp # Media downloader for many sites
    zoxide # Rust alt to cd but smarter, integrates with yazi

    # Gaming
    vulkan-tools # 64-Bit vulkaninfo
    pkgs.pkgsi686Linux.vulkan-tools # 32-bit vulkaninfo
    mesa-demos # Testing stuff, glxinfo
    gamemode
    libstrangle
    mangohud
    vkBasalt

    # File management
    detox # Sanitizes filenames of special chars
    fdupes # Find dupe files
    p7zip # This should just be a dependency smh
    unar # The great archive tool
    yazi # The Rust TUI file manager

    # Media Apps
    ffmpeg # The video converter
    imv # Minimal Wayland image viewer
    inkscape
    mpv # The God of video / media players
    obs-studio
    pandoc # Ultimate Document converter
    texliveFull # Needed by pandoc & others to convert to PDF
    zathura # The PDF viewer

    # Misc software
    jetbrains.idea-community-bin # The Java IDE
    keepassxc
    libreoffice # The FOSS office suite
    lua-language-server # Lua LSP
    marksman # A nice Markdown LSP
    nil # Nix LSP, RIP rnix dev
    temurin-bin-17 # 2024 and we still can't include these things in-app
    vscodium

    # I'm somehow missing these utils? these should be default but ok. 
    coreutils
    gnugrep
    gawk
    findutils
    procps
  ];


  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  programs.gnome-disks.enable = true;

  # Tool to run unpatched binaries, may or may not use
  #
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #
  # ];

  # Set shell to Fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # List services that you want to enable:

  # Enable GVfs for file managers like Thunar and other tools
  # services.gvfs.enable = true;

  # Enable Flatpak globally
  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  xdg.portal.config = {
    common.default = "hyprland";
  };
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Enable the firewall.
  networking.firewall.enable = true;
  networking.nameservers = [
    "9.9.9.9"
    "2620:fe::fe"
  ];
  networking.networkmanager.dns = "none";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enables some "experimental" stuff, basically anything that's important but might change.
  # Enable the nix-command utility, a must have I'm told. Along with flakes, another prime pick.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  # Hyprland
  # programs.hyprland = {
  #   enable = true;
  # };
  
  # Some environment variables
  # Enable ozone for chromium apps, aka wayland support
  environment.sessionVariables = {
    LIBSEAT_BACKEND = "logind";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  
  services.dbus.enable = true;

}
