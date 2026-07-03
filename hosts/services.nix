{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  services.v2raya.enable = false;

  # udev rules for MTP access (Android over USB via jmtpfs)
  services.udev.packages = [ pkgs.libmtp.out ];
}
