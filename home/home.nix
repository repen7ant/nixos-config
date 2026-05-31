{ user, ... }:

{
  imports = [
    ./niri
    ./noctalia.nix
    ./kitty
    ./fuzzel
    ./yazi
    ./fastfetch
    ./starship
    ./nvim
    ./nvim-tools.nix
    ./bash.nix
    ./git.nix
    ./packages.nix
    ./theme.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
