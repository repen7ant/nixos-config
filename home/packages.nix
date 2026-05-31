{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    git
    wget
    ripgrep
    tree
    wl-clipboard

    starship
    zoxide
    fzf
    fd
    yazi
    fastfetch
    btop

    kitty
    fuzzel
    playerctl
    brightnessctl
    cliphist

    bibata-cursors
  ];
}
