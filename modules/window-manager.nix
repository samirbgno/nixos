{ config, lib, pkgs, ... }:

let 
  user = config.dotfiles.user;
  font = config.dotfiles.font;
  monitors = config.dotfiles.monitors;
  fontPackage = config.dotfiles.fontPackage;
in {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      grim
      slurp
      nwg-displays
      wl-clipboard
      brightnessctl
    ];
  };
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway > "$HOME/.config/sway/log" 2>&1
    fi
  '';
  services.pipewire.wireplumber.extraConfig = {
    "10-disable-bluetooth-autoconnect" = {
      "monitor.bluez.properties" = {
        "bluez5.auto-connect" = [ ];
      };
    };
  };
  home-manager.users.${user} = {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        bars = [];
        modifier = "Mod4";
        defaultWorkspace = "workspace number 1";
        workspaceAutoBackAndForth = true;
        workspaceOutputAssign = lib.pipe monitors.profiles [
          builtins.attrValues
          (builtins.sort (a: b: builtins.length a > builtins.length b))
          (builtins.map (devices:
            builtins.map (d:
              let
                n = monitors.devices.${d.monitor}.name;
              in
                builtins.map (w: { workspace = w; name = n; }) d.workspaces
            ) devices
          ))
          lib.flatten
          lib.unique
          (builtins.groupBy (n: n.workspace))
          (lib.mapAttrsToList (w: pairs: {
            workspace = w;
            output = lib.concatMapStringsSep " " (p: p.name) pairs;
          }))
        ];
        output = builtins.listToAttrs (lib.mapAttrsToList (_: device: {
          name = device.name;
          value = {
            inherit (device) mode;
          };
        }) monitors.devices);
        input."*" = {
          xkb_layout = "us";
          xkb_variant = "dvorak";
          xkb_options = "compose:ralt";
        };
        window = {
          border = 1;
          titlebar = false;
          commands = let
            enableFloating = attr: values: map (val: {
              command = "floating enable";
              criteria = { ${attr} = val; };
            }) values;
          in
            (enableFloating "window_role" [ "pop-up" "bubble" "dialog" ]) ++
            (enableFloating "window_type" [ "dialog" "splash" "toolbar" "utility" ]);
        };
        gaps = {
          inner = 12;
          outer = -12;
          smartGaps = true;
        };
        colors = let
          fg = "#ffffff";
          bg = "#000000";
          window_colors = {
            text = fg;
            border = fg;
            indicator = fg;
            background = bg;
            childBorder = fg;
          };
        in {
          urgent = window_colors;
          focused = window_colors;
          unfocused = window_colors; 
          placeholder = window_colors;
          focusedInactive = window_colors;
          background = window_colors.background;
        };
        keybindings = {
          "Mod4+Apostrophe" = "kill"; 
          "Mod4+Space" = "exec fuzzel";
          "Mod4+Escape" = "exec swaylock";
          "Mod4+Return" = "exec footclient";

          "Mod4+s" = "floating toggle";
          "Mod4+f" = "fullscreen toggle";
          
          "Mod4+w" = "move scratchpad";
          "Mod4+v" = "scratchpad show";

          #"Mod4+a" = "exec swaync-client -t -sw";

          "Shift+Print" = "exec grim - | wl-copy";
          "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";

          "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioMicMute" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ toggle";

          "Mod4+Shift+Escape" = "reload";

          "Mod4+Up" = "focus up";
          "Mod4+Left" = "focus left";
          "Mod4+Down" = "focus down";
          "Mod4+Right" = "focus right";

          "Mod4+Shift+Up" = "move up";
          "Mod4+Shift+Left" = "move left";
          "Mod4+Shift+Down" = "move down";
          "Mod4+Shift+Right" = "move right"; 

          "Mod4+1" = "workspace number 1";
          "Mod4+2" = "workspace number 2";
          "Mod4+3" = "workspace number 3";
          "Mod4+4" = "workspace number 4";
          "Mod4+5" = "workspace number 5";
          "Mod4+6" = "workspace number 6";
          "Mod4+7" = "workspace number 7";
          "Mod4+8" = "workspace number 8";

          "Mod4+bracketleft" = "workspace prev_on_output";
          "Mod4+bracketright" = "workspace next_on_output";

          "Mod4+Shift+1" = "move container to workspace number 1";
          "Mod4+Shift+2" = "move container to workspace number 2";
          "Mod4+Shift+3" = "move container to workspace number 3";
          "Mod4+Shift+4" = "move container to workspace number 4";
          "Mod4+Shift+5" = "move container to workspace number 5";
          "Mod4+Shift+6" = "move container to workspace number 6";
          "Mod4+Shift+7" = "move container to workspace number 7";
          "Mod4+Shift+8" = "move container to workspace number 8";
        };
      };
      extraConfig = "exec_always systemctl --user reload kanshi";
    };
    services.wlsunset = {
      enable = true;
      #duration = 1800;
      sunset = "20:00";
      sunrise = "06:00";
    };
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = let
        fg = "ffffffff";
        bg = "00000066";
        fg-alt = "00000080";
        transparent = "00000000";
      in {
        clock = true;
        indicator = true;
        screenshots = true;
        effect-blur = "7x5";
        indicator-radius = 150;
        indicator-thickness = 5;
        effect-vignette = "0.5:0.5";
        font = font;
        key-hl-color = bg;
        inside-color = bg;
        inside-ver-color = bg;
        inside-clear-color = bg;
        inside-caps-lock-color = bg;
        inside-wrong-color = "ff00001A";
        ring-color = fg;
        ring-ver-color = fg;
        ring-clear-color = fg;
        ring-caps-lock-color = fg;
        ring-wrong-color = "ff0000ff";
        text-color = fg;
        text-ver-color = fg;
        text-clear-color = fg;
        text-wrong-color = fg;
        text-caps-lock-color = fg;
        line-color = transparent;
        line-ver-color = transparent;
        line-clear-color = transparent;
        line-wrong-color = transparent;
        line-caps-lock-color = transparent;
      };
    };
    #services.swaync = {
    #  enable = true;
    #  settings = {
    #    cssPriority = "user";
    #    ignore-gtk-theme = true;
    #    control-center-positionY = "center";
    #    widgets = [
    #      "mpris"
    #      "volume"
    #      "backlight"
    #      #"menubar"
    #      #"slider"
    #      #"inhibitors"
    #      "notifications"
    #      "buttons-grid"
    #    ];
    #    widget-config = {
    #      volume.label = "";
    #      mpris = {
    #        autohide = true;
    #        loop-carousel = true;
    #        show-album-art = "always";
    #      };
    #      backlight = {
    #        min = 2;
    #        label = "󰃠";
    #        subsystem = "backlight";
    #        device = "intel_backlight";
    #      };
    #      buttons-grid = {
    #        buttons-per-row = 4;
    #        actions = [
    #          {
    #            label = "H";
    #            type = "toogle";
    #            active = true;
    #            command = "sh -c 'swaync-client -d -sw'";
    #            update-command = "sh -c 'set +e;swaync-client -D'";
    #          }
    #        ];
    #      };
    #    };
    #  };
    #  style = ''
    #    * {
    #      font-family: ${font};
    #    }
    #
    #    :root {
    #      --fg: #ffffff;
    #      --bg: #000000;
    #    }
    #    .control-center {
    #      border-radious: 0;
    #      border: 1px solid var(--fg);
    #      background: var(--bg);
    #    }
    #  '';
    #};
    programs.fuzzel = {
      enable = true;
      settings = {
        border.radius = 0;
        main = {
          lines = 12;
          width = 2 * 12;
          inner-pad = 12;
          use-bold = true;
          dpi-aware = "no";
          terminal = "foot";
          vertical-pad = 12;
          horizontal-pad = 12;
          icon-theme = "Papirus-Dark";
          font = "${font}:size=12";
        };
        colors = let
          fg = "ffffffff";
          bg = "000000ff";
          alt = "969696ff";
        in {
          text = fg;
          input = fg;
          match = alt;
          border = fg;
          prompt = fg;
          selection = bg;
          background = bg;
          placeholder = fg;
          selection-text = fg;
          selection-match = alt;
        };
      };
    };
    gtk = {
      enable = true;
      colorScheme = "dark";
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
    home.pointerCursor = {
      size = 24;
      enable = true;
      gtk.enable = true;
      sway.enable = true;
      name = "Simp1e";
      package = pkgs.simp1e-cursors;
    };
    services.kanshi = {
      enable = true;
      systemdTarget = "sway-session.target";
      settings = lib.mapAttrsToList (name: devices: {
        profile = {
          inherit name;
          outputs = builtins.map (d:
            let
              m = monitors.devices.${d.monitor};
            in {
              criteria = m.name;
              mode = m.mode;
            } // lib.optionalAttrs (d.position != null) {
              position = d.position;
            }
          ) devices;
        };
      }) monitors.profiles;
    };
  };
  users.users.${user}.extraGroups = [ "video" ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  fonts = {
    packages = [ fontPackage ];
    fontconfig = {
      hinting.enable = false;
      defaultFonts = {
        serif = [ font ];
        sansSerif = [ font ];
        monospace = [ font ];
      };
    };
  };
}
