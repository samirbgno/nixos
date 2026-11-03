{ ... }:

{
  dotfiles = {
    printing.enable = false;
    bluetooth.enable = false;
  };

  services.thermald.enable = true;
  boot = {
    kernelModules = [ "kvm-intel" ];
  };
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
