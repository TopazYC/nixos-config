{ config, pkgs, inputs, ... }:
{
  imports = [
    ../home/niri

    inputs.noctalia.homeModules.default
  ];
  home.username = "Topaz";
  home.homeDirectory = "/home/Topaz";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    ssh-to-age
  ];

  #modules.desktop.niri.enable = true;

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
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
        addKeysToAgent = "no";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
        controlPersist = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github_id";
        identitiesOnly = true;
        extraOptions = {
          StrictHostKeyChecking = "accept-new";
        };
      };
    };
  };


  home.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    # enable native Wayland support for most Electron apps
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    # misc
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "QT_QPA_PLATFORM" = "wayland";
    "SDL_VIDEODRIVER" = "wayland";
    "GDK_BACKEND" = "wayland";
    "XDG_SESSION_TYPE" = "wayland";
  };
  
  programs.noctalia-shell = {
    enable = true;
  };
}
