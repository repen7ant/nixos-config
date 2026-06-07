{ ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  hardware.bluetooth.enable = true;
  services.libinput.enable = true; # touchpad
  networking.enableIPv6 = false; # broken in this VM's QEMU NAT

  system.stateVersion = "25.05";
}
