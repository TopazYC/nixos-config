{
  xdg.configFile."mimeapps.list".force = true;

  # manage $XDG_CONFIG_HOME/mimeapps.list
  # xdg search all desktop entries from $XDG_DATA_DIRS, check it by command:
  #  echo $XDG_DATA_DIRS
  # the system-level desktop entries can be list by command:
  #   ls -l /run/current-system/sw/share/applications/
  # the user-level desktop entries can be list by command(user ryan):
  #  ls /etc/profiles/per-user/ryan/share/applications/
  xdg.mimeApps = {
    enable = true;
    # let `xdg-open` to open the url with the correct application.
    defaultApplications =
      let
        browser = [
          "microsoft-edge.desktop"
          "google-chrome.desktop"
          "firefox.desktop"
        ];
        editor = [
          "emacs.desktop"
          "nvim.desktop"
          "code.desktop"
        ];
        # KDE Ark: 双击压缩包直接打开并浏览内容, 按需解压
        archiver = [ "org.kde.ark.desktop" ];
      in
      {
        "application/json" = browser;
        "application/pdf" = browser; # TODO: pdf viewer

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-wine-extension-ini" = editor;

        # define default applications for some url schemes.
        "x-scheme-handler/about" = browser; # open `about:` url with `browser`
        "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        # https://github.com/microsoft/vscode/issues/146408
        "x-scheme-handler/vscode" = [ "code-url-handler.desktop" ]; # open `vscode://` url with `code-url-handler.desktop`
        "x-scheme-handler/zoommtg" = [ "Zoom.desktop" ];

        # all other unknown schemes will be opened by this default application.
        # "x-scheme-handler/unknown" = editor;

        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop " ];

        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "image/*" = [ "imv-dir.desktop" ];
        "image/gif" = [ "imv-dir.desktop" ];
        "image/jpeg" = [ "imv-dir.desktop" ];
        "image/png" = [ "imv-dir.desktop" ];
        "image/webp" = [ "imv-dir.desktop" ];

        # 压缩包/归档: 双击交给 Ark 打开, 直接浏览内容, 无需先整个解压.
        # 范围与 Ark 自己声明的 MimeType 对齐(去掉 AppImage, 免得双击 AppImage 变成看内容).
        # zip / 7z / rar
        "application/zip" = archiver;
        "application/x-zip-compressed" = archiver;
        "application/x-7z-compressed" = archiver;
        "application/vnd.rar" = archiver;
        "application/x-rar" = archiver;
        "application/x-rar-compressed" = archiver;
        # tar 及其压缩变体
        "application/x-tar" = archiver;
        "application/x-compressed-tar" = archiver;
        "application/x-tarz" = archiver;
        "application/x-bzip-compressed-tar" = archiver;
        "application/x-bzip2-compressed-tar" = archiver;
        "application/x-xz-compressed-tar" = archiver;
        "application/x-lzma-compressed-tar" = archiver;
        "application/x-lzip-compressed-tar" = archiver;
        "application/x-lrzip-compressed-tar" = archiver;
        "application/x-lz4-compressed-tar" = archiver;
        "application/x-zstd-compressed-tar" = archiver;
        "application/x-tzo" = archiver;
        # 单文件压缩流
        "application/gzip" = archiver;
        "application/x-gzip" = archiver;
        "application/x-bzip" = archiver;
        "application/x-bzip2" = archiver;
        "application/x-xz" = archiver;
        "application/x-lzma" = archiver;
        "application/x-lzip" = archiver;
        "application/x-lrzip" = archiver;
        "application/x-lzop" = archiver;
        "application/x-lz4" = archiver;
        "application/zstd" = archiver;
        "application/x-zstd" = archiver;
        "application/zlib" = archiver;
        "application/x-compress" = archiver;
        # 其它归档 / 包格式(Ark 都能浏览)
        "application/x-archive" = archiver;
        "application/java-archive" = archiver;
        "application/x-cpio" = archiver;
        "application/x-bcpio" = archiver;
        "application/x-cpio-compressed" = archiver;
        "application/x-sv4cpio" = archiver;
        "application/x-sv4crc" = archiver;
        "application/x-xar" = archiver;
        "application/x-lha" = archiver;
        "application/x-arj" = archiver;
        "application/arj" = archiver;
        "application/x-stuffit" = archiver;
        "application/x-cd-image" = archiver;
        "application/x-iso9660-image" = archiver;
        "application/vnd.efi.iso" = archiver;
        "application/x-deb" = archiver;
        "application/vnd.debian.binary-package" = archiver;
        "application/x-rpm" = archiver;
        "application/x-source-rpm" = archiver;
        "application/vnd.ms-cab-compressed" = archiver;

        "inode/directory" = [ "yazi.desktop" ];
      };

    associations.removed = {
      # ......
    };
  };
}
