{ config, ... }:
let 
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ../linux/gui.nix ];
}
