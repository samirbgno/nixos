{ ... }:

{
  networking.hostName = "thinkchad";

  imports = builtins.map (module: ../modules/${module}.nix)[
    display-manager
    window-manager
    storage
    users
    nixos
    boot
  ];
}
