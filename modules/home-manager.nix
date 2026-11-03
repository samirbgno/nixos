{ config, inputs, ... }:

let
  user = config.dotfiles.user;
  stateVersion = config.dotfiles.stateVersion;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${user}.home = {
      username = user;
      homeDirectory = "/home/${user}/.dotfiles";
      stateVersion = stateVersion;
    };
  };
}
