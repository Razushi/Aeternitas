# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

  networking.hostName = "Solaris"; # Define your hostname.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable GNOME
  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };

  # Enable fstrim, really should be enabled by default.
  services.fstrim.enable = true;

  # Controls RGB
  services.hardware.openrgb.enable = true;

  # Enable configs for desktop RTX3060
  desktop3060.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Kanata, keyboard remap program
  services.kanata = {
    enable = false;
    keyboards.main.config = ''
    (defsrc
      caps
      lmeta lalt
    )

    (defalias
      esc2ctrl (tap-hold 150 150 esc lctrl)
    )

    (deflayer main
      @esc2ctrl
      lalt lmeta
    )
    '';
    keyboards.main.devices = [
      "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd"
    ];
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
    jack.enable = true;
  };

  # Enable bluetooth support
  hardware.bluetooth.enable = true;

  # Explicit firmware packages (Can't be too sure...)
  boot.extraModulePackages = [ pkgs.linux-firmware ];

  # Redistributable firmware for AMD GPU and CPU
  hardware.enableRedistributableFirmware = true;

  # Ensure the AMDGPU driver is loaded
  services.xserver.videoDrivers = [ "amdgpu" ];


  # OpenGL and Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # DriSupport
    extraPackages32 = with pkgs.pkgsi686Linux; [
      pkgs.pkgsi686Linux.mesa
    ];
  };
  
  # Docker, nuff said
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_25;
  virtualisation.waydroid.enable = true;

  # Not needed for AMD GPU's)
  # hardware.nvidia-container-toolkit.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

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
    xdg-desktop-portal-gtk # Needed for cursor in some flatpak gtk apps
    powertop # Power consumption moniter

    # From the moment I understood the weakness of the GUI...
    btop # Neat system monitor
    du-dust # Dust, a rust written du replacement
    eza # Rust based ls alternative
    fastfetch # Neofetch but written in C and maintained
    fd # Rust alternative to the find command
    fzf # Great cl fuzzy finder in GO
    git
    glow # Command line Markdown viewer
    helix
    imagemagick
    neovim # The new classic.
    ripgrep # Rust based recursive line search tool
    smartmontools # Disk health monitoring stuff
    starship # Terminal prompt written in Rust
    tldr # Community made, minimal man pages
    wget
    yt-dlp # Media downloader for many sites
    zoxide # Rust alt to cd but smarter, integrates with yazi
    thinkfan

    # Gaming
    vulkan-tools # 64-Bit vulkaninfo
    pkgs.pkgsi686Linux.vulkan-tools # 32-bit vulkaninfo
    mesa-demos # Testing stuff, glxinfo
    libstrangle
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
    # tauon # Music player (Flatpak)
    texliveFull # Needed by pandoc & others to convert to PDF
    zathura # The PDF viewer

    # Misc software
    jetbrains.idea-community-bin # The Java IDE
    keepassxc
    libreoffice # The FOSS office suite
    lua-language-server # Lua LSP
    marksman # A nice Markdown LSP
    nil # Nix lsp, RIP rnix dev
    temurin-bin-17 # 2024 and we still can't include these things in-app
    vscodium
    vmware-workstation
    k3d # Kubernetes with Docker
    vmware-workstation # vm/hypervisor, yes GTK boxes exist but like uni assignments.

    # REMOVE AFTER:
    jdk22
    maven
    mysql-workbench
    libimobiledevice
    usbmuxd
    ifuse
    usbutils

    waydroid # android 
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
}
