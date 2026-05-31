{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    git
    wget
    ripgrep
    tree
    wl-clipboard
    nil # Nix LSP
  ];
}
