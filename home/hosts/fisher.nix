{ config, pkgs, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../linux/gui.nix
    ../linux/ai
  ];

  home.username = "Topaz";
  home.homeDirectory = "/home/Topaz";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    ssh-to-age
  ];

  programs.microsoft-edge = {
    enable = true;
  };

  modules.desktop.camera.enable = true;
  modules.desktop.gaming.enable = true;
  modules.desktop.niri.enable = true;
  modules.desktop.office.enable = true;

  # Tray icon for the system-wide Syncthing service (see
  # modules/nixos/desktop/networking/syncthing.nix). It talks to the local
  # GUI on 127.0.0.1:8384.
  #
  # Not using home-manager's `services.syncthing.tray` here: that unit has
  # `Requires = [ "tray.target" ]`, which niri does not provide, so it would
  # fail to start.
  systemd.user.services.syncthingtray = {
    Unit = {
      Description = "Syncthing tray";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.syncthingtray-minimal}/bin/syncthingtray --wait";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # PC: keep the screen on longer than on the laptop.
  #  modules.desktop.hypridle = {
  #    keyboardBacklightTimeout = 900;
  #    screenOffTimeout = 1200;
  #    lockTimeout = 1800;
  #  };

  xdg.configFile."niri/niri-hardware.kdl".source =
    mkSymlink "${config.home.homeDirectory}/nixos-config/hosts/fisher/niri-hardware.kdl";

  programs.git = {
    enable = true;
    settings.user.name = "TopazYC";
    settings.user.email = "ycroaker@gmail.com";
    settings = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;

      gpg.format = "ssh";
      user.signingkey = "~/.ssh/github_sign.pub";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };

  };
  # programs.ssh = {
  #   enable = true;
  #   enableDefaultConfig = false;
  #   settings={
  #     "*" = {
  #       AddKeysToAgent = "yes";
  #       ControlMaster = "auto";
  #       ControlPath = "~/.ssh/master-%r@%h:%p";
  #       Compression = false;
  #       ControlPersist="yes";
  #       ForwardAgent = false;
  #       HashKnownHosts = false;
  #       ServerAliveInterval = 0;
  #       ServerAliveCountMax = 3;
  #       UserKnownHostsFile = "~/.ssh/known_hosts";
  #    };
  #     "github.com" = {
  #       Hostname = "github.com";
  #       User = "git";
  #       IdentityFile = "~/.ssh/github_id";
  #       IdentitiesOnly = true;
  #         StrictHostKeyChecking = "accept-new";
  #       #extraOptions = { };
  #     };
  #   };
  #};
}
