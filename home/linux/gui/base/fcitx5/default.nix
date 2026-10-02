{
  config,
  pkgs,
  catppuccin-fcitx5,
  fcitx5-theme-mint,
  ...
}:
{
  catppuccin.fcitx5.enable = false;
  xdg.dataFile."fcitx5/themes" = {
    source = "${catppuccin-fcitx5}/src";
    recursive = true;
  };
  xdg.dataFile = {
    "fcitx5/themes/mint-blue-dark".source = "${fcitx5-theme-mint}/mint-blue-dark";

    "fcitx5/themes/mint-blue-light".source = "${fcitx5-theme-mint}/mint-blue-light";

    "fcitx5/themes/mint-green-dark".source = "${fcitx5-theme-mint}/mint-green-dark";

    "fcitx5/themes/mint-green-light".source = "${fcitx5-theme-mint}/mint-green-light";
  };
  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
    "fcitx5/conf/classicui.conf" = {
      source = ./classicui.conf;
      force = true;
    };
    #    "mozc/config1.db".source =
    #      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/linux/gui/base/fcitx5/mozc-config1.db";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool # GUI for fcitx5
      fcitx5-gtk # gtk im module

      # Chinese
      fcitx5-rime # for flypy chinese input method
      # fcitx5-chinese-addons # we use rime instead

      # Japanese
      # ctrl-i / F7 - convert to takakana
      # ctrl-u / F6 - convert to hiragana
      #fcitx5-mozc-ut # Moze with UT dictionary

      # Korean
      #fcitx5-hangul
    ];
    # fcitx5.settings = {
    #   addons.classicui = {
    #     globalSection = {
    #       "Vertical Candidate List" = true;
    #       "PerScreenDPI" = true;
    #     };
    #   };
    # };
  };
}
