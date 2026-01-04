{ ... }:

{
  users.users.samir = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
