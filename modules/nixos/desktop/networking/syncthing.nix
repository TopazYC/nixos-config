{
  config,
  lib,
  myvars,
  ...
}:
# =============================================================
#
# Syncthing - continuous, peer-to-peer file synchronisation.
#
# Runs as a *system* service under the desktop user, so files in the home
# directory keep their normal ownership and are readable/writable by
# Syncthing without permission juggling.
#
# The web GUI/API is bound to localhost only:
#
#   http://127.0.0.1:8384
#
# Open it on this machine to pair devices. For remote access, tunnel it over
# SSH or Tailscale instead of exposing the GUI:
#
#   ssh -L 8384:127.0.0.1:8384 Topaz@<host>
#
# `openDefaultPorts` opens TCP/UDP 22000 (transfers) and UDP 21027 (LAN
# discovery). For syncing across the internet, either forward 22000/TCP on
# one side or use the Tailscale network already configured in
# modules/nixos/desktop/networking/tailscale.nix - Syncthing discovers peers
# over the tailnet automatically.
#
# Devices and folders are declared declaratively in `settings` below, so a
# rebuild recreates the same setup and no GUI clicking is needed. The module
# pushes `settings` through the REST API on activation.
#
# `overrideDevices`/`overrideFolders` both default to true: anything added
# through the GUI is deleted on the next activation. Add new devices/folders
# here instead, and list *all* of them.
#
# The IDs used below are stable, public identifiers (not secrets):
#   - folder ID `rqc6i-sysoa` is the identity the phone paired with; changing
#     it makes Syncthing treat the folder as new and re-sync from scratch.
#   - the local device (this machine) is implicit and must not be listed.
#
# =============================================================
let
  cfg = config.modules.desktop.syncthing;
  username = myvars.username;
  homeDir = "/home/${username}";
in
{
  options.modules.desktop.syncthing = {
    enable = lib.mkEnableOption "Syncthing continuous file synchronisation" // {
      default = true;
    };

    syncDir = lib.mkOption {
      type = lib.types.path;
      default = "${homeDir}/Syncthing";
      description = ''
        Directory created as a convenient root for synced folders. The
        declarative `RimeSync` folder below lives under it.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = username;
      group = "users";

      # Keep config/keys in the user's home; the default would be under
      # /var/lib/syncthing, which does not match a per-user desktop setup.
      dataDir = homeDir;
      configDir = "${homeDir}/.config/syncthing";

      # Local-only GUI: do not expose the API to the LAN.
      guiAddress = "127.0.0.1:8384";

      # TCP/UDP 22000 for transfers, UDP 21027 for local discovery.
      openDefaultPorts = true;

      # Declarative devices/folders. Keep IDs stable; `id` is what peers pair
      # with, while `label` is only the display name.
      settings = {
        devices = {
          "REDMI-K80U" = {
            id = "JDHDOJQ-HE5T6OJ-YACPLBU-DKB5MSO-BTD4FCV-4QLT4LI-AN23ASX-PJP6RQD";
            addresses = [ "dynamic" ];
          };
        };

        folders = {
          "RimeSync" = {
            # Original folder ID from the GUI setup: changing it would make
            # Syncthing treat this as a different folder on the phone.
            id = "rqc6i-sysoa";
            label = "RimeSync";
            path = "${cfg.syncDir}/RimeSync";
            devices = [ "REDMI-K80U" ];
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.syncDir} 0700 ${username} users -"
    ];
  };
}
