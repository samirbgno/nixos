{ config, pkgs, ... }:

{
  options.dotfiles.programs = {
    firefox.enable = mkEnableOption "Enable firefox browser";
    google-chrome.enable = mkEnableOption "Enable google chrome browser";
  };
  config = let 
    user = config.dotfiles.user;
  in mkMerge [

    # --- firefox --- #
    (mkIf config.dotfiles.programs.firefox.enable {
      home-manager.users.${user} = {
        programs.firefox = {
          enable = true;
          profiles.${user} = {
            settings = {
              "browser.startup.page" = 3;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.ctrlTab.sortByRecentlyUsed" = false;
              "browser.link.open_newwindow" = 3;
              "browser.tabs.loadInBackground" = true;
              "browser.tabs.warnOnClose" = false;
              "browser.warnOnQuitShortcut" = false;
              "browser.tabs.hoverPreview.showThumbnails" = false;
              "privacy.userContext.enabled" = false;
              "sidebar.verticalTabs" = false;
              "sidebar.revamp" = false;
              "layout.css.prefers-color-scheme.content-override" = 2;
              "browser.display.document_color_use" = 1;
              "font.size.variable.x-western" = 16;
              "browser.zoom.full" = true;
              "layout.spellcheckDefault" = 0;
              "browser.download.dir" = "/home/${user}/downloads";
              "browser.download.useDownloadDir" = true;
              "browser.download.always_ask_before_handling_new_types" = false;
              "media.eme.enabled" = true;
              "browser.preferences.defaultPerformanceSettings.enabled" = false;
              "layers.acceleration.disabled" = true;
              "general.autoScroll" = true;
              "general.smoothScroll" = true;
              "widget.gtk.overlay-scrollbars.enabled" = false;
              "accessibility.browsewithcaret" = false;
              "layout.css.always_underline_links" = false;
              "accessibility.typeaheadfind" = false;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
              "media.hardwaremediakeys.enabled" = true;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
              "browser.urlbar.suggest.searches" = false;
              "browser.urlbar.showSearchSuggestionsFirst" = false;
              "browser.search.suggest.enabled.private" = false;
              "browser.urlbar.suggest.trending" = false;
              "browser.urlbar.suggest.recentsearches" = false;
              "browser.urlbar.suggest.history" = false;
              "browser.urlbar.suggest.bookmark" = false;
              "browser.urlbar.suggest.openpage" = false;
              "browser.urlbar.suggest.topsites" = false;
              "browser.urlbar.suggest.engines" = false;
              "browser.urlbar.shortcuts.bookmarks" = false;
              "privacy.globalprivacycontrol.enabled" = true;
              "signon.rememberSignons" = false;
              "signon.autofillForms" = false;
              "signon.generation.enabled" = false;
              "signon.firefoxRelay.feature" = "disabled";
              "signon.management.page.breach-alerts.enabled" = false;
              "browser.aboutConfig.showWarning" = false;
              "browser.translations.automaticallyPopup" = false;
              "browser.compactmode.show" = true;
              "extensions.autoDisableScopes" = 0;
              "extensions.enabledScopes" = 15;
              "browser.tabs.inTitlebar" = 0;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "devtools.debugger.remote-enabled" = true;
              "devtools.chrome.enabled" = true;
            };
          };
          policies = {
            DownloadDirectory = "/home/${user}/downloads";
          };
        };
        services.psd = {
          enable = true;
          browsers = [ "firefox" ];
        };
      };
    })

    # --- google chrome --- #
    (mkIf config.dotfiles.programs.google-chrome.enable {
      home-manager.users.${user} = {
        home.packages = with pkgs; [
          (unstable.google-chrome.override {
            commandLineArgs = [
              "--restore-last-session"
              "--hide-crash-restore-bubble"
            ];
          })
        ];
        services.psd = {
          enable = true;
          browsers = [ "google-chrome" ];
        };
      };
    })
  ];
}
