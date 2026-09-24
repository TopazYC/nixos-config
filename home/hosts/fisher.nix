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
    settings={
      "*" = {
        AddKeysToAgent = "yes";
        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%h:%p";
        Compression = false;
        ControlPersist="yes";
        ForwardAgent = false;
        HashKnownHosts = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        UserKnownHostsFile = "~/.ssh/known_hosts";
     };
      "github.com" = {
        Hostname = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github_id";
        IdentitiesOnly = true;
          StrictHostKeyChecking = "accept-new";
        #extraOptions = { };
      };
    };
  };
}
