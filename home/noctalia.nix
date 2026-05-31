{ inputs, config, dotfiles, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell.enable = true;

  xdg.configFile."noctalia".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/noctalia/config";
}
