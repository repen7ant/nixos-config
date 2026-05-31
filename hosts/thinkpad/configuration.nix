{ ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  hardware.bluetooth.enable = true;
  services.libinput.enable = true; # touchpad

  system.stateVersion = "25.05";
}
