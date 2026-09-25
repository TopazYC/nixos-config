{
  config,
  mysecrets,
  ...
}:
{
  # home.file.".ssh/romantic.pub".source = "${mysecrets}/public/romantic.pub";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      AddKeysToAgent = "yes";
      ControlMaster = "auto";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "yes";

      Compression = true;
      ForwardAgent = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
    };

    settings = {
      "github.com" = {
        # avoid clash fake-IP6 hang, see modules/nixos/desktop/networking/clash-verge.nix
        AddressFamily = "inet";
        HostName = "github.com";
        Port = 443;
        User = "git";
	IdentityFile = "~/.ssh/github_id";
        IdentitiesOnly = true;
      };
    };
  };
}
