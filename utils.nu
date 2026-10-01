def repeat-str [s: string, n: int] {
  (1..$n | each { $s } | str join)
}

# ================= NixOS related =========================

export def nixos-switch [
    name: string
    mode: string
    verbosity: string
] {
    if $mode not-in ["switch" "boot"] {
        error make { msg: $"unsupported deployment mode '($mode)'; expected switch or boot" }
    }
    if $verbosity not-in ["normal" "debug"] {
        error make { msg: $"unsupported verbosity '($verbosity)'; expected normal or debug" }
    }

    print $"nixos-switch '($name)' in '($mode)' mode with '($verbosity)' verbosity..."
    print (repeat-str "=" 50)
    if $verbosity == "debug" {
        # show details via nix-output-monitor
        nom build $".#nixosConfigurations.($name).config.system.build.toplevel" --accept-flake-config --show-trace --verbose
        nixos-rebuild $mode --sudo --flake $".#($name)" --accept-flake-config --show-trace --verbose
    } else {
        nixos-rebuild $mode --sudo --flake $".#($name)" --accept-flake-config
    }
}
