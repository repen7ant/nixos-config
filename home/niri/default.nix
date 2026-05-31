{ config, dotfiles, ... }:

{
  programs.niri.config = null;

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/niri/config.kdl";
}
