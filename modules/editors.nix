{ config, lib, pkgs, ... }:

with lib;

{
  options.dotfiles.programs = {
    neovim.enable = mkEnableOption "Enable neovim editor";
    vscode.enable = mkEnableOption "Enable vscode editor";
  };
  config = let 
    user = config.dotfiles.user;
  in mkMerge [

    # --- neovim --- #
    (mkIf config.dotfiles.programs.neovim.enable {
      home-manager.users.${user} = {
        programs.neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          defaultEditor = true;
          extraConfig = ''
            lua << EOF
            vim.g.mapleader = " "
            vim.opt.tabstop = 2
            vim.opt.number = true
            vim.opt.shiftwidth = 2
            vim.opt.expandtab = true
            vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
            vim.api.nvim_set_hl(0, "NonText", { bg = "none", ctermbg = "none" })
            vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
            EOF
          '';
        };
        xdg.desktopEntries.nvim = {
          noDisplay = true;
          name = "neovim wrapper";
        };
      };
    })

    # --- visual studio code --- #
    (mkIf config.dotfiles.programs.vscode.enable {
      home-manager.users.${user} = {
        programs.vscode = {
          enable = true;
          package = pkgs.unstable.vscode.override {
            commandLineArgs = "--password-store=gnome-libsecret";
          };
          mutableExtensionsDir = true;
          profiles.default = {
            mutableUserSettings = true;
            userSettings = {
              "editor.tabSize" = 2;
              "editor.insertSpaces" = true;
              "editor.minimap.enabled" = false;
              "files.trimFinalNewlines" = true;
              "files.insertFinalNewline" = true;
              "workbench.startupEditor" = "none";
              "window.density.layout" = "compact";
              "editor.renderFinalNewline" = "off";
              "biome.suggestInstallingGlobally" = false;
              "workbench.activityBar.location" = "bottom";
            };
          };
        };
        xdg.desktopEntries.code = {
          name = "VSCode";
          icon = "vscode";
          exec = "code %F";
        };
      };
    })
  ];
}
