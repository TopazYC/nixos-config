{ config,pkgs, ... }:
let 
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ../linux/gui.nix ];

  home.username = "Topaz";
  home.homeDirectory = "/home/Topaz";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    ssh-to-age
  ];

  programs.microsoft-edge = {
    enable = true;
  };

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
        addKeysToAgent = "yes";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
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
}
