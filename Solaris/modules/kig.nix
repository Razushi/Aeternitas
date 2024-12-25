# Kig module
{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    kig-test.enable = lib.mkEnableOption "Enables kig";
  };

  config = lib.mkIf config.kig-test.enable { environment.systemPackages = with pkgs; [ vlc ]; };

}
