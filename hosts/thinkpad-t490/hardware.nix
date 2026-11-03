{ pkgs, ... }:

{
  dotfiles = {
    printing.enable = true;
    bluetooth.enable = true;
  };
  services.thermald.enable = true;
  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd.kernelModules = [ "i915" ];
  };
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };
}
