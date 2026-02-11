{ config, pkgs, ... }:
{
  home.username = "Topaz";
  home.homeDirectory = "/home/Topaz";

  home.packages = with pkgs; [

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
    };
  };
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
	HostName github.com
        User git
	IdentityFile ~/.ssh/id_github
	IdentitiesOnly yes
	StrictHostKeyChecking accept-new
	UserKnownHostsFile ~/.ssh/known_hosts
    '';
  };
}
