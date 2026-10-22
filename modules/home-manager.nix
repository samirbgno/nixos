{ config, inputs, pkgs, ... }:

let 
  user = config.dotfiles.user;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ]; 

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    home = "/home/${user}/.dotfiles";
  };
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${user}.home = {
      username = user;
      stateVersion = "26.05";
      homeDirectory = "/home/${user}/.dotfiles";
    };
  };
}
