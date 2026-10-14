{
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib;
let
  cfgWayland = config.modules.desktop.wayland;
in
{
  imports = [
    ./base
    ../base

    ./desktop
  ];

  options.modules.desktop = {
    wayland = {
      enable = mkEnableOption "Wayland Display Server";
    };
  };

  config = mkMerge [
    (mkIf cfgWayland.enable {
      ####################################################################
      #  NixOS's Configuration for Wayland based Window Manager
      ####################################################################
      services = {
        xserver.enable = false; # disable xorg server
        # https://wiki.archlinux.org/title/Greetd
        greetd = {
          enable = true;
          useTextGreeter = true;
          #settings.default_session.command =
          #    "${pkgs.tuigreet}/bin/tuigreet --time --remember \
          #      --sessions /run/current-system/sw/share/wayland-sessions \
          #      --sessions /run/current-system/sw/share/xsessions";
          #
          settings = {
            default_session = {
              command = lib.concatStringsSep " " [
                "${pkgs.tuigreet}/bin/tuigreet"
                "--time"
                "--remember"
                "--remember-session"
                "--asterisks"
                # "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
                "--cmd ${config.programs.niri.package}/bin/niri-session"
              ];
            };
          };
        };
      };

    })
  ];
}
