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
        plymouth = rec {
          enable = true;
          theme = "minimal";
          font = let 
            pkg = config.dotfiles.fontPackage;
            name = config.dotfiles.font;
            family = replaceStrings [ " " ] [ "" ] name;
            dir = removeSuffix "NerdFont" family;
          in "${pkg}/share/fonts/truetype/NerdFonts/${dir}/${family}Mono-SemiBold.ttf";
          themePackages = let 
            script = pkgs.writeText "${theme}.script" ''
              Window.SetBackgroundTopColor(0, 0, 0);
              Window.SetBackgroundBottomColor(0, 0, 0);

              global.font = "Sans 12";
              global.cx = Window.GetWidth() / 2;
              global.y = Window.GetHeight() / 2 + 6;
              global.count = -1;
              global.tick = 0;
              global.active = 0;

              label.image = Image.Text("Enter password:", 1, 1, 1, 1, global.font);
              label.sprite = Sprite(label.image);
              label.sprite.SetPosition(global.cx - label.image.GetWidth() / 2, global.y - 36);
              label.sprite.SetOpacity(0);

              cursor.image = Image.Text("|", 1, 1, 1, 1, global.font);
              cursor.sprite = Sprite(cursor.image);
              cursor.sprite.SetOpacity(0);
              global.cw = cursor.image.GetWidth();

              stars.sprite = Sprite();
              stars.sprite.SetOpacity(0);

              fun layout(n) {
                w = 0;
                if (n > 0) {
                  s = "";
                  for (i = 0; i < n; i++) s = s + "*";
                  stars.image = Image.Text(s, 1, 1, 1, 1, global.font);
                  stars.sprite.SetImage(stars.image);
                  w = stars.image.GetWidth();
                  stars.sprite.SetOpacity(1);
                } else {
                  stars.sprite.SetOpacity(0);
                }
                x = global.cx - (w + global.cw) / 2;
                stars.sprite.SetPosition(x, global.y);
                cursor.sprite.SetPosition(x + w, global.y);
              }

              fun on_password(prompt, bullets) {
                if (global.active && bullets == global.count) return;
                if (!global.active) {
                  global.active = 1;
                  label.sprite.SetOpacity(1);
                }
                global.count = bullets;
                global.tick = 0;
                cursor.sprite.SetOpacity(1);
                layout(bullets);
              }

              fun on_normal() {
                global.active = 0;
                global.count = -1;
                label.sprite.SetOpacity(0);
                stars.sprite.SetOpacity(0);
                cursor.sprite.SetOpacity(0);
              }

              fun on_refresh() {
                if (!global.active) return;
                global.tick = global.tick + 1;
                if (global.tick == 25) cursor.sprite.SetOpacity(0);
                else if (global.tick >= 50) {
                  global.tick = 0;
                  cursor.sprite.SetOpacity(1);
                }
              }

              Plymouth.SetDisplayPasswordFunction(on_password);
              Plymouth.SetDisplayNormalFunction(on_normal);
              Plymouth.SetRefreshFunction(on_refresh);
            '';
          in [
            (pkgs.runCommand "plymouth-theme-${theme}" { } ''
              dir=$out/share/plymouth/themes/${theme}
              mkdir -p $dir
              cp ${script} $dir/${theme}.script
              cat > $dir/${theme}.plymouth <<EOF2
              [Plymouth Theme]
              Name=${theme}
              Description=${theme}
              ModuleName=script

              [script]
              ImageDir=$dir
              ScriptFile=$dir/${theme}.script
              EOF2
            '')
          ];
        };
      };
    })
  ];
}
