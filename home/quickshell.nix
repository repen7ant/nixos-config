{ pkgs, config, dotfiles, ... }:

{
  home.packages = with pkgs; [
    quickshell
    wlsunset
    swaybg
    glib
  ];

  xdg.configFile."quickshell/bar".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/quickshell/bar";
}
