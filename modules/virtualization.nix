{ config, pkgs, lib, ... }:

let 
  user = config.dotfiles.user;
in {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings.shutdown-timeout = 15;
  };
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      extraConfig = "timeout = 120";
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        package = pkgs.qemu_kvm;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
  };
  systemd = {
    services.libvirtd.wantedBy = lib.mkForce [ ];
    sockets = {
      virtlogd.wantedBy = [ "sockets.target" ];
      libvirtd.wantedBy = [ "sockets.target" ];
      virtlockd.wantedBy = [ "sockets.target" ];
    };
  };
  environment.systemPackages = with pkgs; [
    spice-gtk
    virt-manager
  ];
  networking = {
    bridges.virbr0.interfaces = [ ];
    interfaces.virbr0.useDHCP = false;
  };
  users.users.${user}.extraGroups = [
    "docker"
    "libvirtd"
  ];
}
