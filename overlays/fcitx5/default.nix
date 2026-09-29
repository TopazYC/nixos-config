# 参考 https://github.com/NixOS/nixpkgs/blob/e4246ae1e7f78b7087dce9c9da10d28d3725025f/pkgs/tools/inputmethods/fcitx5/fcitx5-rime.nix
_:
(_: super: {
  rime-data = ./rime-data;
  fcitx5-rime = super.fcitx5-rime.override { rimeDataPkgs = [ ./rime-data ]; };

  # used by macOS Squirrel
  #flypy-squirrel = ./rime-data-flypy;
})
