{ lib }:
{
  username = "Topaz";
  userfullname = "Yu Huang";
  useremail = "ycroaker@gmail.com";
  networking = import ./networking.nix { inherit lib; };

  hashedPassword = "$6$gkkW1D96uttd8jLg$4gQ6rDPirswJv6b31gleekF31KTLjjpLIrlBNTKAwwFE71urrCEk.70MWZOQPRae0o9cXgy/jB9TGX.icSI7z.";
}
