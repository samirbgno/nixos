{ ... }:

{
  dotfiles = {
    openssh.enable = true;
    programs = {
      # --- editors --- #
      neovim.enable = true;
    };
    dev = {
      languages = [ "nix" ];
    };
  };
}
