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
    ./bash.nix
    ./git.nix
    ./packages.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
