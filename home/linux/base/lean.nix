{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.modules.lean;
in
{
  options.home.modules.lean = {
    enable = lib.mkEnableOption "lean4";
  };

  # remember to enable :lang lean in Doom Emacs
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lean4
    ];
  };
}
