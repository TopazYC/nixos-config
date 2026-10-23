{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
}:

rustPlatform.buildRustPackage rec {
  pname = "file-minnow";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Puddings22";
    repo = "File-Minnow-Linux";
    rev = "v${version}";
    hash = "sha256-ESyJS+zwR4O4lqhrPdHagBkOUDpj+pBt3Pt32Yn8P+k=";
  };

  cargoHash = "sha256-5Zi7vQ1S9lct6cKVBIV0/dRg2ZXS1ZaCFaRJLdBru1c=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  # Upstream's test-suite launches the GUI/indexer and is not sandbox-friendly.
  doCheck = false;

  postInstall = ''
    install -Dm644 packaging/file-minnow.desktop \
      $out/share/applications/file-minnow.desktop
    install -Dm644 packaging/file-minnow.svg \
      $out/share/icons/hicolor/scalable/apps/file-minnow.svg

    for size in 16 22 24 32 48 64 128 256; do
      install -Dm644 "packaging/icons/file-minnow-$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/file-minnow.png"
    done

    # Point the launcher at the store binary instead of relying on $PATH.
    substituteInPlace $out/share/applications/file-minnow.desktop \
      --replace-fail 'Exec=file-minnow ' "Exec=$out/bin/file-minnow "
  '';

  meta = {
    description = "Instant file search for Linux: a fast, lightweight Everything alternative";
    longDescription = ''
      File Minnow indexes file and folder names once, keeps the index up to date
      in real time, and finds files as you type. It provides a native GTK 3
      interface, a global hotkey, a tray icon and a CLI.
    '';
    homepage = "https://github.com/Puddings22/File-Minnow-Linux";
    changelog = "https://github.com/Puddings22/File-Minnow-Linux/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "file-minnow";
    platforms = lib.platforms.linux;
  };
}
