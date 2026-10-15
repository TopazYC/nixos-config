{ mylib, pkgs, ... }:
{
  # wayland related
  home.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    # enable native Wayland support for most Electron apps
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    # misc
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    # NOTE: do NOT force SDL_VIDEODRIVER=wayland globally. Several native
    # Linux games ship their own SDL2 built WITHOUT the Wayland backend
    # (e.g. Don't Starve Together's bin64/lib64/libSDL2-2.0.so.0 has zero
    # wayland symbols). Forcing wayland makes them abort at startup with:
    #   Unable to initialize SDL: wayland,x11 not available
    # Let SDL auto-detect, or override per game in Steam launch options.
    "GDK_BACKEND" = "wayland";
    "XDG_SESSION_TYPE" = "wayland";
  };

  home.packages = with pkgs; [
    wl-clipboard # copying and pasting
    hyprpicker # color picker
    brightnessctl
    # audio
    alsa-utils # provides amixer/alsamixer/...
    # screen recording
    wf-recorder # screen recording

    virt-viewer # vnc connect to the libvirt VMs
  ];

  # Emergency session-menu fallback; the normal flow uses Noctalia's session panel.
  programs.wlogout.enable = true;

  # auto mount usb drives
  services = {
    udiskie.enable = true;
    # syncthing.enable = true;
  };
}
