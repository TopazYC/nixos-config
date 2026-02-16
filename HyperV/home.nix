{ config, pkgs, ... }:
{
  home.username = "Topaz";
  home.homeDirectory = "/home/Topaz";

  home.packages = with pkgs; [
    ssh-to-age
  ];
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings.user.name = "TopazYC";
    settings.user.email = "ycroaker@gmail.com";
    settings = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/sign_github.pub";
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
        # strictHostKeyChecking = "accept-new";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
        extraOptions = {
          StrictHostKeyChecking = "accept-new";
        };
      };
    };
  };
}
