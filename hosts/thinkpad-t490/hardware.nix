{ modulesPath, pkgs, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  services.thermald.enable = true;
  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd.kernelModules = [ "i915" ];
    loader.efi.canTouchEfiVariables = false;
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
