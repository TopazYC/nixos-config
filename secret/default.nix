{ config, pkgs, sops-nix, secrets, ...}:
let
  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = "Topaz";
  };
in
{
  imports = [ sops-nix.nixosModules.sops ];
  
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.generateKey = true;
    environment = {
      SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/etc/ssh/ssh_host_ed25519_key";
    };

    # temporarily
    # validateSopsFiles = false;
  };
  sops.secrets = {
    "host_user_password" = {
      sopsFile = "${secrets}/secrets/hyperv.yaml";
      neededForUsers = true;
    };
    "host_root_password" = {
      sopsFile = "${secrets}/secrets/hyperv.yaml";
      neededForUsers = true;
    };
    "github_id" = {
      sopsFile = "${secrets}/secrets/hyperv.yaml";
      path = "/home/Topaz/.ssh/github_id";
    } // user_readable;
    "github_id_pub" = {
      sopsFile = "${secrets}/secrets/hyperv.yaml";
      path = "/home/Topaz/.ssh/github_id.pub";
    } // user_readable;
    "github_sign" = {
      sopsFile = "${secrets}/secrets/hyperv.yaml";
      path = "/home/Topaz/.ssh/github_sign";
    } // user_readable;
    "github_sign_pub" = {
      sopsFile = "${secrets}/secrets/hyperv.yaml";
      path = "/home/Topaz/.ssh/github_sign.pub";
    } // user_readable;
  };
}
