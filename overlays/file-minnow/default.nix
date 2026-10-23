# File Minnow: instant file search for Linux (Everything alternative).
# Upstream is not in nixpkgs, so it is packaged here and exposed through this
# overlay as `pkgs.file-minnow`.
_: final: _prev: {
  file-minnow = final.callPackage ./package.nix { };
}
