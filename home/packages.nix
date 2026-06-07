{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- base CLI ---
    neovim
    git
    wget
    ripgrep
    tree
    unzip
    fd
    wl-clipboard

    # --- shell ---
    starship
    zoxide
    fzf
    fastfetch

    # --- desktop / niri binds ---
    kitty
    fuzzel
    playerctl
    brightnessctl
    cliphist
    bibata-cursors
    yazi
    btop
    xdg-utils

    # --- applications ---
    claude-code # proprietary garbage
    github-desktop
    librewolf
    mpv
    libreoffice-still
    gpu-screen-recorder-gtk
    dbeaver-bin
    feishin

    helium
    tor-browser
    telegram-desktop
    qbittorrent
    blender
    # v2raya
  ];
}
