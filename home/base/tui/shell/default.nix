{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.static;
  configpath = "${config.home.homeDirectory}/nixos-config/home/base/tui/shell";
in
{
  options.modules.static = {
    enable = lib.mkEnableOption "Static Configuration Mode";
  };
  config = {
    xdg.configFile =
      let
        mkSource =
          path: if cfg.enable then ./${path} else config.lib.file.mkOutOfStoreSymlink "${configpath}/${path}";
      in
      {
        "nushell/modules.nu".source = mkSource "modules.nu";
        # "nushell/modules".recursive = true;
        "nushell/modules".source = mkSource "modules";
      };
    programs.nushell = {
      extraConfig = ''
        use ./modules.nu *
      '';
    };
  };
}
