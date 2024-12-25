{ config, pkgs, ... }:

{
  imports = [
    ./rtx3060Nvidia.nix
    ./unfreeList.nix
  ];
}
