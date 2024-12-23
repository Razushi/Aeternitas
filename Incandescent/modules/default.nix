{ config, pkgs, ... }:

{
  imports = [
    ./rtx3060Nvidia.nix
    ./unfreeList.nix
    ./hyprland_stuff.nix
  ];
}
