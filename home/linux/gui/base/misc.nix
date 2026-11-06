{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate

    # KDE 归档管理器: 不解压就能浏览压缩包内容, 也可以只解压选中的文件.
    # NOTE: 必须用 kdePackages.ark; 顶层的 pkgs.ark 是 Posit 的 R kernel,
    # 名字相同但完全是另一个程序(装错会让 thunar-archive-plugin 失效).
    kdePackages.ark

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    ##netease-cloud-music-gtk
    go-musicfox
    # my custom hardened packages
    nixpaks.qq
    # nixpaks.telegram-desktop
    # qqmusic
    bwraps.wechat
    # discord # update too frequently, use the web version instead
  ];

  # allow fontconfig to discover fonts and configurations installed through home.packages
  # Install fonts at system-level, not user-level
  fonts.fontconfig.enable = false;

}
