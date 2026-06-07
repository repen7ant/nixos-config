{ pkgs, lib, dotfiles, ... }:

{
  # waypaper — GTK wallpaper picker with a preview grid. Uses swaybg as backend
  # (already installed), so the lock-screen blur still reads the wallpaper from
  # swaybg's cmdline. niri runs `waypaper --restore` at startup and binds the GUI.
  home.packages = [ pkgs.waypaper ];

  # Seed waypaper's config once (backend=swaybg, folder=repo walls) so nothing
  # has to be set by hand. It's a mutable copy — waypaper rewrites it when you
  # pick a wallpaper — so we only drop it in when it doesn't already exist.
  home.activation.seedWaypaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="$HOME/.config/waypaper/config.ini"
    if [ ! -f "$cfg" ]; then
      run mkdir -p "$(dirname "$cfg")"
      run cp ${dotfiles}/home/waypaper/config.ini "$cfg"
      run chmod u+w "$cfg"
    fi
  '';
}
