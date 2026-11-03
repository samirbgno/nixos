{ ... }:

{
  dotfiles = {
    printing.enable = false;
    bluetooth.enable = false;
  };

  services = {
    earlyoom.enable = true;
    thermald.enable = true;
  };
  boot = {
    kernelModules = [ "kvm-intel" ];
  };
  hardware = {
    graphics.enable = true;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
