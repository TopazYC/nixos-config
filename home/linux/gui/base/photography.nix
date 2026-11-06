{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.camera;
in
# photography - RAW development and image editing
{
  options.modules.desktop.camera = {
    enable = lib.mkEnableOption "RAW photo editing suite (darktable, RawTherapee, RapidRAW)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      darktable # non-destructive RAW workflow: develop, organize, print
      rawtherapee # RAW image processing with a detailed control over the pipeline
      rapidraw # lightweight, GPU-accelerated RAW editor (Tauri)
    ];
  };
}
