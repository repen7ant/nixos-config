{ pkgs, ... }:

let
  heliumWrapped = pkgs.symlinkJoin {
    name = "helium-screenshare-fix";
    paths = [ pkgs.helium ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/helium \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib \
        --set-default GBM_BACKENDS_PATH /run/opengl-driver/lib/gbm \
        --set-default __EGL_VENDOR_LIBRARY_DIRS /run/opengl-driver/share/glvnd/egl_vendor.d \
        --set-default __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS /run/opengl-driver/share/egl/egl_external_platform.d
    '';
  };
in
{
  home.packages = with pkgs; [
    # --- base CLI ---
    neovim
    git
    wget
    ripgrep
    tree
    unzip
    fd
    wl-clipboard

    # --- shell ---
    starship
    zoxide
    fzf
    fastfetch

    # --- desktop / niri binds ---
    kitty
    fuzzel
    playerctl
    brightnessctl
    cliphist
    bibata-cursors
    yazi
    btop
    xdg-utils

    # --- applications ---
    claude-code # proprietary garbage
    github-desktop
    librewolf
    mpv
    libreoffice-still
    gpu-screen-recorder-gtk
    dbeaver-bin
    feishin
    calibre

    heliumWrapped
    tor-browser
    telegram-desktop
    qbittorrent
    blender
  ];
}
