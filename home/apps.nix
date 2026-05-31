{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    github-desktop
    librewolf
    v2raya
    mpv
    libreoffice-still
    gpu-screen-recorder-gtk
    dbeaver-bin

    # helium (not in nixpkgs)
    # tor-browser
    # telegram-desktop
    # discord
    # qbittorrent
  ];
}
