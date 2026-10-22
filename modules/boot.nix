{ pkgs, lib, ... }:

{
  boot = {
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.package = pkgs.systemd.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
            sed -i 's/message, SIZE_MAX);/"\\n  Enter password:", SIZE_MAX);/g' src/shared/ask-password-api.c
            sed -i 's/"(press TAB for no echo) "/""/g' src/shared/ask-password-api.c
            sed -i 's/&& !FLAGS_SET(flags, ASK_PASSWORD_SILENT)/\&\& 0/g' src/shared/ask-password-api.c
            sed -i 's/glyph(GLYPH_BULLET)/"*"/g' src/shared/ask-password-api.c 
        '';
      });
    };
    kernelParams = [
      "quiet"
      "vt.global_cursor_default=0"
    ];
    loader = {
      timeout = 0;
      systemd-boot = {
	      enable = true;
        editor = false;
      };
    };
  };
}
