{ lib }:
{
  username = "Topaz";
  userfullname = "Yu Huang";
  useremail = "ycroaker@gmail.com";
  networking = import ./networking.nix { inherit lib; };
}
