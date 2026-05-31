{ pkgs, ... }:

{
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita-dark";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "gnome";
    style.name = "adwaita-dark";
  };
}
