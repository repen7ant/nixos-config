{ config, dotfiles, ... }:

{
  xdg.configFile."fastfetch".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/fastfetch";
}
