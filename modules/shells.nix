{ config, pkgs, lib,... }:

with lib;

{
  options.dotfiles.shell = mkOption {
    type = types.enum [ "zsh" ];
    default = "zsh";
    description = "Default shell.";
  };

  config = let
    user = config.dotfiles.user;
    shell = config.dotfiles.shell;
  in mkMerge [

    # --- zsh --- #
    (mkIf (shell == "zsh") {
      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      home-manager.users.${user}.programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        initContent = ''
          cd() {
            if [ $# -eq 0 ]; then
              builtin cd "/home/${user}"
            else
              builtin cd "$@"
            fi
          }
  
          if [[ -o interactive && "$PWD" == "$HOME" ]]; then
            builtin cd "/home/${user}"
          fi

          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
          typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
          typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir prompt_char)
          typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
          typeset -g POWERLEVEL9K_MODE=ascii
          typeset -g POWERLEVEL9K_ICON_PADDING=none
          typeset -g POWERLEVEL9K_BACKGROUND=
          typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
          typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=" "
          typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
          typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
          typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
          typeset -g POWERLEVEL9K_SHOW_RULER=false
  
          typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=""
          typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=15

          typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

          typeset -g POWERLEVEL9K_DIR_FOREGROUND=15
          typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
          typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=15
          typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION=">"
          typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION="<"
          typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION="V"
          typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=15
          typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=124

          typeset -g POWERLEVEL9K_STATUS_OK=false
          typeset -g POWERLEVEL9K_STATUS_ERROR=false
        '';
      };
    })

  ];
}
