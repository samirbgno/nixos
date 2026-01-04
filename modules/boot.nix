{ ... }:

{
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "rd.systemd.show_status=false"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      systemd-boot = {
	enable = true;
        editor = false;
	configurationLimit = 10;
      };
    };
  };
}
