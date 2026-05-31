{ config, dotfiles, ... }:

{
  xdg.configFile."yazi".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/yazi";
}
