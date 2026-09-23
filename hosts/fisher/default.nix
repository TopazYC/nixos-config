{
  disko,
  myvars,
  lib,
  pkgs,
  ...
}:
#############################################################
#
#  Ai - my main computer, with NixOS + I5-13600KF + RTX 4090 GPU, for gaming & daily use.
#
#############################################################
let
  hostName = "Fisher"; # Define your hostname.

#  inherit (myvars.networking) mainGateway mainGateway6 nameservers;
#  inherit (myvars.networking.hostsAddr.${hostName}) iface ipv4 ipv6;
#  ipv4WithMask = "${ipv4}/24";
#  ipv6WithMask = "${ipv6}/64";
in
{
  imports = [
#    disko.nixosModules.default
     ./configuration.nix

    # disks
  #  ./disko-fs.nix
  #  ./disko-fs-data.nix
  #  ./netdev-mount.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  #  ./hardware-intel.nix
  #  ./hardware-nvidia.nix

  #  ./preservation.nix
  #  ./secureboot.nix

  #  ./restic.nix

  #  # others
  #  ./ai
  ];

  # Zram consumes physical memory for compression, which can cause a deadlock and system hang if the model size approaches the physical memory limit.
  # Disable the whole module (zram device + its swappiness=180 sysctl tunings); this host uses a disk swapfile instead.
  # modules.zram.enable = false;

  # zswap: compressed writeback cache in front of the disk swapfile.
  # Keeps swapped cold anon pages compressed in RAM instead of the SSD, which frees more
  # page cache for the ~78GB mmap'd LLM weights (mmap file pages never go through zswap).
  # Safe here: disk swapfile remains the real backing store, no zram deadlock structure.
  # - zstd: CPU is not the bottleneck here (llama.cpp peaks ~30% util); its ~2.5x ratio
  #   keeps ~5G more anon bytes in the capped pool than lz4, and ~5us decompress is noise
  #   vs the ~100us SSD fault it avoids.
  # - 10% pool (~9G): the module default 25% (~23G) would compete with the weight cache.
#  boot.zswap = {
#    enable = true;
#    compressor = "zstd";
#    maxPoolPercent = 10;
#  };

#  services.sunshine.enable = true;
#  services.tuned.ppdSettings.main.default = lib.mkForce "performance";

  # modules.btrbk.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
