{ inputs, user, dotfiles, pkgs, ... }:

{
  imports = [
    inputs.niri.nixosModules.niri
    ./services.nix
  ];

  # --- Boot ---
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # --- Nix / flakes / binary caches ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    auto-optimise-store = true;
  };
  niri-flake.cache.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "discord"
      "claude-code"
    ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  programs.nh = {
    enable = true;
    flake = dotfiles;
  };

  # --- Networking ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  # IPv6 is broken in the VM's QEMU NAT
  networking.enableIPv6 = false;

  # --- SSH ---
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # change later to public key
      PasswordAuthentication = true;
    };
  };

  # --- Time / locale ---
  time.timeZone = "Asia/Almaty";

  # --- Audio (pipewire) ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- Services noctalia relies on ---
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # --- Compositor ---
  programs.niri.enable = true;
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri-unstable;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # --- Display manager ---
  services.displayManager.ly.enable = true;

  # --- zram swap ---
  zramSwap.enable = true;

  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # --- User ---
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.bash;
  };
}
