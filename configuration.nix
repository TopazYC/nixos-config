# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "Topaz";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  networking.hostName = "YC-NixOS"; 
  time.timeZone = "Asia/Beijing";
  i18n.defaultLocale = "en_US.UTF-8";
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3391 ];
  };
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.niri}/bin/niri";
    port = 3391;
    openFirewall = true;
  };
  
  # set the default editor to be vim
  environment.variables.EDITOR = "vim";

  users.users.Topaz = {
    isNormalUser = true;
    description = "Topaz";
    extraGroups = ["networkmanager" "wheel" "audio"];
    uid = 1000;
    initialPassword = "123456";
    packages = with pkgs; [ ];
  };

  users.users.root = {
    initialPassword = "123456";
  };


  # i3 configuration
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";

    desktopManager = {
      xterm.enable = true;
    };
   
    windowManager.i3 = {
      enable = true;
     extraPackages = with pkgs; [
        # dmenu #application launcher most people use
        # i3status # gives you the default i3 status bar
        # i3blocks #if you are planning on using i3blocks over i3status
        i3lock
     ];
    };
  };
  programs.niri.enable = true;
  services.displayManager.defaultSession = "niri";


  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git vim emacs gtk3 wget curl
   i3 i3-gaps i3lock dmenu 
    alacritty # Terminal Emulator
    polybarFull # Statusbar (i3status alternative)
    rofi # Tool for searching applications (dmenu alternative)
    xorg.xev # Tool to capture information about button presses
    toybox # Numerous unix command line utilities
    siji    # Font required for polybar
    unifont # Font required for polybar 
    xrdp
    
    # Multimedia Applications:
    # Includes audio control, media players, etc.
    # pavucontrol # pulseaudio frontend
    vlc
    feh # image viewer to set background 
    imagemagick

    # File Management:
    xfce.thunar
    ranger

    # Security Tools:
    keepassxc

    xorg.libX11
                xorg.libXcursor
                xorg.libXi
                xorg.libXrandr
  ];

  services.pulseaudio.enable = false;
  # hardware.pulseaudio.enable = false; (deprecated)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
};


service.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    PermitEmptyPasswords = false;
    KbdInteractiveAuthentication = false;
    ChallengeResponseAuthentication = false;
    X11Forwarding = true;
    AllowTcpForwarding = true;
  };
  ports = [35555];
  allowoUsers = [ "Topaz" ];
  denyUsers = [ "root" ];
  openFirewall = true;
};


}
