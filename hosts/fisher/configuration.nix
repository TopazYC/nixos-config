# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib,mylib, pkgs, nixpkgs-unstable, inputs, sops-nix, ... }:

{
  imports =
  ( map mylib.relativeToRoot [
    "os/desktop.nix"
    "os/fonts.nix"
  ]);

  system.stateVersion = "25.11";
  networking.hostName = "Fisher"; 

  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.windows = {
    "nvme0n1p1" = {
      title = "Win 11";
      efiDeviceHandle = "FS0";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 3391 ];
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
    #hashedPassword = "$6$UoPit41NYB.9dn00$YeomG3oTeBqfQfQxezRJ0LszdDeuyRtuhoQ5mYOtTuyxQDxus773WHLjtxVJz.S33D1mFLA7catWSHc3VUxdX1";
    # hashedPasswordFile = config.sops.secrets.host_user_password.path;
    hashedPasswordFile = "/etc/nixos/passwd.file";
  };

  users.users.root = {
    # hashedPasswordFile = config.sops.secrets.host_root_password.path;
    hashedPasswordFile = "/etc/nixos/passwd.file";
    #hashedPassword = "$6$UoPit41NYB.9dn00$YeomG3oTeBqfQfQxezRJ0LszdDeuyRtuhoQ5mYOtTuyxQDxus773WHLjtxVJz.S33D1mFLA7catWSHc3VUxdX1";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git vim wget curl tree
    alacritty # Terminal Emulator
    microsoft-edge
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

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 15";
    flake = "/etc/nixos";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.niri.enable = true;
  # programs.hyprland.enable = true;
  modules.desktop.fonts.enable = true;

  #modules.desktop.wayland.enable = true;


  programs.clash-verge = {
    enable = true;
    serviceMode = true;
    autoStart = true;
  };
  networking.firewall = {
    trustedInterfaces = [ "Mihomo" ];
    extraReversePathFilterRules = ''
      iifname { "Mihomo" } accept comment "trusted interface"
    '';
  };
}
