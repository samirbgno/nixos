{ config, pkgs, lib, ... }:

with lib;

let
  user = config.dotfiles.user;
  langs = config.dotfiles.dev.languages;
in {
  options.dotfiles.dev = {
    claude-code.enable = mkEnableOption "Enable Claude Code.";
    languages = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of programming languages to install.";
    };
  };

  config = mkMerge [

    # --- git --- #
    {
      home-manager.users.${user}.programs = {
        git = {
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
        gh = {
          enable = true;
          settings.git_protocol = "ssh";
        }; 
      };
    }

    # --- direnv --- #
    {
      home-manager.users.${user}.programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
        config = {
          whitelist = {
            prefix = [
              "/home/${user}/repos"
            ];
          };
        };
      };
    }

    # --- languages --- #
    {
      home-manager.users.${user}.home.packages = with pkgs; [ ]
        ++ optionals (elem "nix" langs) [
          nixd
          nixfmt
          statix
          deadnix
          waypipe
          nixpkgs-vet
          nixpkgs-review
        ]
        ++ optionals (elem "latex" langs) [
          texliveFull
        ]
        ++ optionals (elem "c" langs) [
          gcc
          gnumake
        ];
    }

    # --- claude-code --- #
    (mkIf config.dotfiles.dev.claude-code.enable {
      home-manager.users.${user}.programs.claude-code = {
        enable = true;
      };
    })

  ];
}
