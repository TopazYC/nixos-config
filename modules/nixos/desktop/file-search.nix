{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    fsearch = {
      enable = lib.mkEnableOption "FSearch, a fast GTK file search utility (Everything alternative)" // {
        default = true;
      };
    };

    file-minnow = {
      enable = lib.mkEnableOption "File Minnow, instant file search with a live index" // {
        default = false;
      };
    };
  };

  config = {
    environment.systemPackages =
      lib.optional cfg.fsearch.enable pkgs.fsearch
      ++ lib.optional cfg.file-minnow.enable pkgs.file-minnow;
  };
}
