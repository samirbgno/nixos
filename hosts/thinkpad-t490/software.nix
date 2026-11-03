{ ... }:

{
  dotfiles = {
    programs = {
      # --- browsers --- #
      firefox.enable = false;
      google-chrome.enable = true;

      # --- editors --- #
      neovim.enable = true;
      vscode.enable = true;

      # --- tools --- #
      thunar.enable = true;
      immich.enable = false;

      # --- games --- #
      chess.enable = true;
    };
    dev = {
      claude-code.enable = true;
      languages = [ "nix" "latex" ];
    };
  };
}
