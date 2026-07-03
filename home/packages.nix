{ pkgs, configName, ... }:

let
  # nvidia + Wayland breaks the GPU/GBM backend of Chromium/Electron apps
  # (helium's screen share): the renderer needs the real GL/GBM/EGL driver
  # paths. Only used on the nvidia host; other hosts run helium unwrapped.
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
    jmtpfs
    shntool
    cuetools
    flac
    ffmpeg

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
    picard
    gimp

    (if configName == "desktop" then heliumWrapped else helium)
    tor-browser
    telegram-desktop
    qbittorrent
    blender
  ];
}
