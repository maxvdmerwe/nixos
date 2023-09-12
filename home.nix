{ config, pkgs, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "max";
  home.homeDirectory = "/home/max";

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

  # set cursor size and dpi for 4k monitor
#   xresources.properties = {
#     "Xcursor.size" = 16;
#     "Xft.dpi" = 172;
#   };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName  = "Max van der Merwe";
    userEmail = "git@maxvdm.com";

    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/max-git.pub";
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    #### Web ####
    # firefox
    # ungoogled-chromium
    # protonvpn-gui

    #### Mail #####
    #mailspring
    evolution

    #### Media ####
    vlc
    filebot

    #### Discord ####
    betterdiscordctl
    #betterdiscord-installer
    #discord

    #### Spotify ####
    spotify

    #### Telegram ####
    #telegram-desktop

    #### Signal ####
    #signal-desktop

    #### Matrix ####
    #fluffychat
    # #fractal-next

    #### VSCode ####
    vscode

    #### Rclone ####
    rclone
    rclone-browser

    #### Emulation ####
    #ryujinx
    #yuzu-mainline

    #### Backup ####
    pika-backup
    borgbackup

    #### RGB ####
    #ckb-next

    #### Ledger Hardware Crypto Wallet ####
    ledger-live-desktop

    #### Zoom ####
    #zoom-us

    #### Web Dev ####
    hugo

    #### Gnome ####

    #### Gnome system ####
    gnome.gnome-tweaks
    gnome-browser-connector

    #### Gnome Extensions ####
    gnomeExtensions.user-themes
    #gnomeExtensions.gsnap
    #gnomeExtensions.desk-changer
    #gnomeExtensions.tailscale-status
    #gnomeExtensions.just-perfection
    #gnomeExtensions.fuzzy-app-search
    #gnomeExtensions.clipboard-indicator
    #gnomeExtensions.espresso
    #gnomeExtensions.trimmer
    #gnomeExtensions.noannoyance-2
    #gnomeExtensions.rclone-manager
    #gnomeExtensions.battery-time-2
    #gnomeExtensions.supergfxctl-gex
    #gnomeExtensions.autohide-volume
    #gnomeExtensions.autohide-battery
    #gnomeExtensions.time-in-date-menu
    #gnomeExtensions.fullscreen-avoider
    #gnomeExtensions.tray-icons-reloaded
    #gnomeExtensions.airpods-battery-status

    #gnomeExtensions.smart-auto-move

    #gnomeExtensions.spotify-tray
    #gnomeExtensions.material-shell

    #### Magic wormhole P2P file transfer ####
    # magic-wormhole-rs

    #### Neofetch ####
    neofetch

    #### Virtualization ####
    qemu
    OVMFFull
    libguestfs
    dmg2img
    virt-manager
    libvirt

    #### Archive management ####
    p7zip
    zstd

    #### Asus ####
    asusctl
    supergfxctl

    #### Proton ####
    lutris
    #wineWowPackages.unstableFull # wine packages for running windows software/games
    wineWowPackages.waylandFull # same as above for wayland
    winetricks # wine manager
    protontricks # steam game bases wine manager

    #### Networking ####
    winbox # Mikrotik manager
    trayscale # Tailscale gui manager
    mtr # A network diagnostic tool
    iperf3 # tool to test network throughput with matching server/client
    dnsutils  # `dig` + `nslookup`
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    dig

    #### System ####
    pciutils # lspci
    usbutils # lsusb
    fio # IO Benchmark
    # gnumake # Compiler
    # gccgo13 # C Compiler
    xwayland # allow x.org programs to run under wayland
    starship # theme for zsh
    nerdfonts # fonts required for starship
    protonup-ng # downloader for proton-ge runners
    # python3
    docker-compose # declarative manager for docker OCI containers
    btrfs-progs # Utilities for the btrfs filesystem
    exiftool
    unzip
    go
    nodejs
    # libiconv
    # cargo
    # rustc
    # rust-analyzer
    # rustfmt
    # clippy
    # pkg-config
    # openssl
    # gccgo13
  ];

  # ssh remote host configs
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "ares" = {
      hostname = "10.0.0.2";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "terra" = {
      hostname = "10.0.0.3";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "orion" = {
      hostname = "100.112.75.88";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "lux" = {
      hostname = "172.16.0.212";
      proxyJump = "100.96.163.55";
      user = "max";
      identityFile = "/home/max/.ssh/max-a17-lux";
      };
      "u334582.your-storagebox.de" = {
      hostname = "u334582.your-storagebox.de";
      user = "u334582";
      port = 23;
      identityFile = "/home/max/.ssh/hetzner-borg";
      };
      "github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "/home/max/.ssh/max-git";
      };
      "gitea.svdm.me" = {
      hostname = "10.0.0.3";
      user = "git";
      port = 2022;
      identityFile = "/home/max/.ssh/max-git";
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
  };
  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # settings = {
    # };
  };


  # nixpkgs.config = {
  #   ungoogled.enableWideVine = true;
  #   chromium.enableWideVine = true;
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
