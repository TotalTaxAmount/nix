let
  # RTX 3070 Ti
  gpuIDs = [
    "10de:25a0" # Graphics
    "10de:2291" # Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"

        # "nvidia"
        # "nvidia_modeset"
        # "nvidia_uvm"
        # "nvidia_drm"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };

    hardware = {
      opengl.enable = true;
      # nvidia.prime.offload.enable = lib.optionals cfg.enable ([false]);
    };
    virtualisation = {
      spiceUSBRedirection.enable = cfg.enable;
      libvirtd.enable = cfg.enable;
    };

    programs.virt-manager.enable = cfg.enable;
    environment.systemPackages = with pkgs; [ ] ++ lib.optional cfg.enable (qemu-patched);
    boot.kernelPackages = lib.mkIf (cfg.enable) pkgs.linuxKernel.packages.linux_6_8;
    boot.kernelPatches = lib.mkIf (cfg.enable) [
      {
        name = "fake-rdtsc";
        patch = ./linux-fake-rdtsc.patch;
      }
    ];
  };
}
