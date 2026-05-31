{ config, dotfiles, ... }:

{
  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/kitty";
}
