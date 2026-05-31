{ config, dotfiles, ... }:

{
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/starship/starship.toml";
}
