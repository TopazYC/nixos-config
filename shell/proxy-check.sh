sudo cat /proc/$(pidof nix-daemon)/environ | tr '\0' '\n'
