{ config, inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = let
    user = config.dotfiles.user;
  in {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${user}.home = {
      username = user;
      homeDirectory = "/home/${user}/.dotfiles";
      stateVersion = config.dotfiles.stateVersion;
    };
  };
}
