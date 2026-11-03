{ pkgs, ... }:
# =============================================================
#
# Sync Fcitx5/Rime user data once at login, *before* fcitx5 starts.
#
# Rime's "Sync" menu item is just `rime_dict_manager --sync` run from
# ~/.local/share/fcitx5/rime (it reads installation.yaml from the current
# directory to find `installation_id` and `sync_dir`).
#
# fcitx5 keeps the LevelDB lock on rime_ice.userdb while it runs, so the CLI
# fails with "LOCK: Resource temporarily unavailable" if it is already up.
# This unit is therefore ordered before fcitx5-daemon.service and runs at
# user-login time (default.target), when the input method has not started yet.
#
# Trade-off: there is no timer, so if you stay logged in for days without
# logging out, no new sync happens. Log out/in (or `systemctl --user start
# rime-sync`) to trigger one.
#
# Syncthing keeps doing the actual transport continuously; this only
# regenerates the `*.userdb.txt` snapshot it carries.
#
# =============================================================
let
  rimeSync = pkgs.writeShellScript "rime-sync" ''
    set -u
    cd "$HOME/.local/share/fcitx5/rime"
    exec ${pkgs.librime}/bin/rime_dict_manager --sync
  '';
in
{
  systemd.user.services.rime-sync = {
    Unit = {
      Description = "Sync Fcitx5 Rime user data at login";
      Before = [ "fcitx5-daemon.service" ];
      ConditionPathExists = "%h/.local/share/fcitx5/rime/installation.yaml";
    };
    Service = {
      Type = "oneshot";
      ExecStart = rimeSync;
      # A stuck sync must not hold the session forever.
      TimeoutStartSec = "30s";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
