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

    # --- applications ---
    claude-code # proprietary garbage
    github-desktop
    librewolf
    v2raya
    mpv
    libreoffice-still
    gpu-screen-recorder-gtk
    dbeaver-bin

    # helium # not in nixpkgs
    # tor-browser
    # telegram-desktop
    # discord # proprietary garbage
    # qbittorrent
    # feishin
  ];
}
