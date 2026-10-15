{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  cfg = config.modules.desktop.office;

  # Order is priority: the first package that declares a MIME type in its
  # `.desktop` files becomes the default application for it.
  #
  # `xdg.mimeApps.defaultApplicationPackages` (enabled in
  # home/linux/gui/base/xdg/mime.nix) derives the associations from the
  # packages themselves, so the long MIME list / desktop-entry names are not
  # duplicated here.
  defaultApplicationPackages =
    let
      order =
        if cfg.defaultApplication == "libreoffice" then
          [
            "libreoffice"
            "onlyoffice"
          ]
        else
          [
            "onlyoffice"
            "libreoffice"
          ];

      packages = {
        libreoffice = cfg.libreoffice.package;
        onlyoffice = cfg.onlyoffice.package;
      };
    in
    map (name: packages.${name}) (lib.filter (name: cfg.${name}.enable) order);
in
{
  options.modules.desktop.office = {
    enable = lib.mkEnableOption "office suites (LibreOffice & ONLYOFFICE) and their document file associations";

    libreoffice = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Install LibreOffice.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs-stable.libreoffice-qt-still;
        defaultText = lib.literalExpression "pkgs-stable.libreoffice-qt-still";
        description = "LibreOffice package to install.";
      };
    };

    onlyoffice = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install ONLYOFFICE Desktop Editors.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.onlyoffice-desktopeditors;
        defaultText = lib.literalExpression "pkgs.onlyoffice-desktopeditors";
        description = "ONLYOFFICE Desktop Editors package to install.";
      };
    };

    defaultApplication = lib.mkOption {
      type = lib.types.enum [
        "onlyoffice"
        "libreoffice"
      ];
      default = "onlyoffice";
      description = ''
        Preferred suite for MIME types that both register. If the preferred
        suite is disabled, the other enabled one is used automatically.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.libreoffice.enable || cfg.onlyoffice.enable;
        message = "modules.desktop.office.enable requires libreoffice.enable and/or onlyoffice.enable.";
      }
    ];

    programs.libreoffice = {
      enable = cfg.libreoffice.enable;
      package = cfg.libreoffice.package;
    };

    programs.onlyoffice = {
      enable = cfg.onlyoffice.enable;
      package = cfg.onlyoffice.package;
    };

    # Spell-check dictionaries only make sense together with LibreOffice.
    home.packages = lib.optionals cfg.libreoffice.enable (
      with pkgs-stable;
      [
        hunspell
        hunspellDicts.en_US
        hyphenDicts.en_GB
      ]
    );

    xdg.mimeApps.defaultApplicationPackages = defaultApplicationPackages;
  };
}
