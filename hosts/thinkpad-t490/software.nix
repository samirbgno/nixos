{ ... }:

{
  dotfiles = {
    programs = {
      # --- browsers --- #
      firefox.enable = true;
      google-chrome.enable = true;

      # --- editors --- #
      neovim.enable = true;
      vscode.enable = true;

      # --- games --- #
      chess.enable = true;
      steam.enable = true;
      minecraft.enable = true;
    };
    dev = {
      claude-code.enable = true;
      languages = [ "nix" "latex" ];
    };
  };
}
