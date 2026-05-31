{ config, dotfiles, ... }:

{
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/nvim";
}
