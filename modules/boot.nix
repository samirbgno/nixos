{ config, pkgs, lib, ... }:

with lib;

{
  options.dotfiles = {
    silentBoot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable silent boot.";
    };
  };
  config = mkMerge [
    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          editor = false;
        };
      };
    }

    (mkIf config.dotfiles.silentBoot.enable {
      boot = {
        loader.timeout = 0;
        consoleLogLevel = 0;
        kernelParams = [
          "quiet"
          "vt.global_cursor_default=0"
        ];
        initrd.systemd.package = pkgs.systemd.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            sed -i 's/message, SIZE_MAX);/"\\n  Enter password:", SIZE_MAX);/g' src/shared/ask-password-api.c
            sed -i 's/"(press TAB for no echo) "/""/g' src/shared/ask-password-api.c
            sed -i 's/&& !FLAGS_SET(flags, ASK_PASSWORD_SILENT)/\&\& 0/g' src/shared/ask-password-api.c
            sed -i 's/glyph(GLYPH_BULLET)/"*"/g' src/shared/ask-password-api.c 
          '';
        });
      };
    })
  ];
}
