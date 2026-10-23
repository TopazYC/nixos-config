# Zotero translation server: a Node.js HTTP service that runs Zotero's
# translators.  It is the local backend used by Emacs' `zotra' package
# (`zotra-backend' = 'translation-server), not the Zotero Connector itself.
#
# nixpkgs already packages it as `pkgs.zotero-translation-server`, so this
# module only wires that package into a systemd service with configurable
# bind address/port.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.zotero-translation-server;
in
{
  options.modules.desktop.zotero-translation-server = {
    enable = lib.mkEnableOption "the Zotero translation server";

    package = lib.mkPackageOption pkgs "zotero-translation-server" { };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        Address the translation server listens on.  Keep the default for
        local-only access; use "0.0.0.0" to expose it on the network (also
        set {option}`openFirewall`).
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1969;
      description = ''
        TCP port the translation server listens on.  Upstream defaults to
        1969, which is also the default of `zotra-server-path' in Emacs'
        `zotra' package.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open {option}`port` in the NixOS firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zotero-translation-server = {
      description = "Zotero translation server (port ${toString cfg.port})";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # The server reads config/default.json5 and modules/translators relative
      # to the package root, so keep the working directory there.
      environment.NODE_CONFIG = builtins.toJSON {
        inherit (cfg) port;
        host = cfg.host;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/translation-server";
        WorkingDirectory = "${cfg.package}/lib/node_modules/translation-server";

        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
