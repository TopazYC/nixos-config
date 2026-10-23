{
  pkgs,
  ...
}:
{
  #home.packages = with pkgs; [
  #nixpaks.firefox
  #];

  # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix

  # open-source upstream Chromium, the base for all the browsers below
  #programs.chromium.enable = true;
  # the world's most widely used browser, with deep Google account and services integration
  #programs.google-chrome.enable = true;
  # Brave's privacy-first build (Shields ad/tracker blocking), minus the crypto/AI extras
  #programs.brave-origin.enable = true;
  # Microsoft's browser, with built-in phishing/malware protection, x86_64 build only
  programs.microsoft-edge = {
    enable = pkgs.stdenv.hostPlatform.isx86_64;

    # Chromium/Edge only read the "system proxy" from GNOME gsettings or KDE
    # kioslaverc.  niri is not a supported desktop, so Clash Verge's system
    # proxy switch is invisible to Edge here.  Point it at Clash Verge's mixed
    # port explicitly instead (see verge.yaml: verge_mixed_port).
    commandLineArgs = [
      "--proxy-server=http://127.0.0.1:7897"
    ];
  };
}
