{ config, pkgs, ... }:

let 
  user = config.dotfiles.user;
in {
  programs.nix-ld.enable = true;
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      gh
      bruno
      discord
      lazydocker

      nodejs_24

      gcc
      gnumake

      claude-code

      localsend

      libreoffice
      sigil
      python3

      texliveFull

      pavucontrol
    ];
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      config.whitelist.prefix = [
        "/home/${user}/repos"
      ];
    };
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "samir";
          email = "samirbgno@gmail.com";
        };
        pull.rebase = true;
        fetch.prune = true;
        core.autocrlf = "input";
        rebase.autoStash = true;
        init.defaultBranch = "main";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 4321 8788 53317 ];
}
