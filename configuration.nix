{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nvidia-config.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-fb4fb2f5-9adc-41f3-959c-4fc6b488f6e6".device = "/dev/disk/by-uuid/fb4fb2f5-9adc-41f3-959c-4fc6b488f6e6";
  boot.initrd.luks.devices."luks-fb4fb2f5-9adc-41f3-959c-4fc6b488f6e6".keyFile = "/crypto_keyfile.bin";


  # SSHFS mounts
  fileSystems."/mnt/terra" =
    { device = "max@10.0.0.3:/mnt/terra";
      fsType = "fuse.sshfs";
      options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/max/.ssh/max-a17-lux" "allow_other" "reconnect"];
    };

  fileSystems."/mnt/ares" =
    { device = "max@10.0.0.2:/mnt/ares";
      fsType = "fuse.sshfs";
      options = [ "x-systemd.automount" "_netdev" "users" "idmap=user" "IdentityFile=/home/max/.ssh/max-a17-lux" "allow_other" "reconnect"];
    };

  # Define your hostname
  networking.hostName = "ursa";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties
  i18n.defaultLocale = "en_ZA.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_ZA.UTF-8";
    LC_IDENTIFICATION = "en_ZA.UTF-8";
    LC_MEASUREMENT = "en_ZA.UTF-8";
    LC_MONETARY = "en_ZA.UTF-8";
    LC_NAME = "en_ZA.UTF-8";
    LC_NUMERIC = "en_ZA.UTF-8";
    LC_PAPER = "en_ZA.UTF-8";
    LC_TELEPHONE = "en_ZA.UTF-8";
    LC_TIME = "en_ZA.UTF-8";
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "za";
    xkbVariant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Docker
  virtualisation.docker = {
  enable = true;
  enableNvidia = true;
  };

  # Main user
  users.users.max = {
    isNormalUser = true;
    description = "Max";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvrt" "input" "libvirtd" "kvm" "qemu-libvirtd" ];
    shell = "/etc/profiles/per-user/max/bin/zsh";
    packages = with pkgs; [ ];
  };

  # Fix wayland windows
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Set default shell to zsh
  environment.shells = with pkgs; [ zsh ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable Flakes and the new command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Garbage collection
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget # core unix downloader
    git # version management
    zsh # terminal shell
    sshfs # remote ssh based filesystems
    sass # libary for gnome dynamic theme
    cfs-zen-tweaks # Kernal tweaks to make system feel more responsive at the cost of throughput
    screen # Allow terminal tasks to run in background
    tailscale # Remote wireguard based p2p vpn
    libimobiledevice # iOS Device libaries
  ];

   environment.gnome.excludePackages = (with pkgs; [
     #gnome-photos
     gnome-tour
   ]) ++ (with pkgs.gnome; [
     cheese # webcam tool
     gnome-music
     #gnome-terminal
     gedit # text editor
     epiphany # web browser
     geary # email reader
     evince # document viewer
     gnome-characters
     totem # video player
     tali # poker game
     iagno # go game
     hitori # sudoku game
     atomix # puzzle game
   ]);

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
        qemu.swtpm.enable = true;
      };
    };

    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];

  # List services that you want to enable:
  programs.steam.enable = true;
  programs.cfs-zen-tweaks.enable = true;
  services.tailscale.enable = true;
  services.asusd.enable = true;
  services.flatpak.enable = true;
  #services.teamviewer.enable= true;
  hardware.ledger.enable = true;
  hardware.bluetooth.disabledPlugins = [ "avrcp" ];
  services.usbmuxd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Allow Tailscale exit node client use
  networking.firewall.checkReversePath = "loose";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
