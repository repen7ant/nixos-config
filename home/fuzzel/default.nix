{ config, dotfiles, ... }:

{
  xdg.configFile."fuzzel".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/fuzzel";
}
