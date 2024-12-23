# Kig module
{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    scythesUnfree.enable = lib.mkEnableOption "Enables Scythe's unfree list";
  };

  config = lib.mkIf config.scythesUnfree.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "davinci-resolve"
        "nvtopPackages.nvidia"
        "nvtopPackages.full"
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
        "libXNVCtrl"
      ];
  };

}
