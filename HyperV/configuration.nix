# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, nixpkgs-unstable, ... }:

{
  system.stateVersion = "25.11";
  networking.hostName = "HyperV"; 
  # systemd.package = nixpkgs-unstable.legacyPackages.${pkgs.system}.systemd;
  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.hypervGuest.enable = true;

  networking.networkmanager.enable = true;
  

  time.timeZone = "Asia/Shanghai";

  networking.proxy.default = "http://YCROAKER-LAPTOP:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3391 ];
  };

  
  # set the default editor to be vim
  environment.variables.EDITOR = "vim";

  users.mutableUsers = false;
  users.users.Topaz = {
    isNormalUser = true;
    description = "Topaz";
    extraGroups = ["networkmanager" "wheel" "audio"];
    uid = 1000;

    packages = with pkgs; [ ];
    hashedPassword = "$6$UoPit41NYB.9dn00$YeomG3oTeBqfQfQxezRJ0LszdDeuyRtuhoQ5mYOtTuyxQDxus773WHLjtxVJz.S33D1mFLA7catWSHc3VUxdX1";
  };

  users.users.root = {
    hashedPassword = "$6$UoPit41NYB.9dn00$YeomG3oTeBqfQfQxezRJ0LszdDeuyRtuhoQ5mYOtTuyxQDxus773WHLjtxVJz.S33D1mFLA7catWSHc3VUxdX1";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git vim wget curl
    alacritty # Terminal Emulator
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


services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    PermitEmptyPasswords = false;
    KbdInteractiveAuthentication = false;
    ChallengeResponseAuthentication = false;
    X11Forwarding = true;
    AllowTcpForwarding = true;
  AllowUsers = [ "Topaz" ];
  DenyUsers = [ "root" ];
  };
  ports = [35555];
  openFirewall = true;
};


}
