{ config, pkgs, ... }:
{
  home.username = "Topaz";
  home.homeDirectory = "/home/Topaz";

  home.packages = with pkgs; [];

  home.stateVersion = "25.05";
}
