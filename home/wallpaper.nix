{ pkgs, dotfiles, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "setwall" ''
      set -eu
      dir="${dotfiles}/home/walls"
      state="$HOME/.config/wallpaper"
      choice=$(ls -1 "$dir" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "wallpaper> ") || exit 0
      if [ -z "$choice" ]; then exit 0; fi
      img="$dir/$choice"
      echo "$img" > "$state"
      ${pkgs.procps}/bin/pkill -x swaybg || true
      ${pkgs.swaybg}/bin/swaybg -i "$img" -m fill &
      disown
    '')
  ];
}
