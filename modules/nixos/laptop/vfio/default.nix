{ pkgs, lib, config, user, ... }:
let
  # RTX 3070 Ti
  gpuIDs = [
    "10de:25a0" # Graphics
    "10de:2291" # Audio
  ];

  cfg = config.vfio;
in {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = lib.mkIf (cfg.enable) {
    boot = {
      initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
      blacklistedKernelModules = [ "nvidia" "nvidiafb" "nouveau" ];

      extraModprobeConfig = ''
        options vfio_iommu_type1 allow_unsafe_interrupts=1 
      '';
      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
        "iommu=pt"
        "kvm.ignore_msrs=1"
        "kvm.report_ignored_msrs=0"
        "video=vesafb:off,efifb=off"
        "vga=off"
        # "default_hugepagesz=1G"
        # "hugepagesz=1G"
        # "hugepages=12"
        # "transparent_hugepage=never"
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
      ];
    };

    hardware = { opengl.enable = true; };

    services.xserver.videoDrivers = [ "modesetting" "fbdev" ];

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu-patched;
          ovmf = {
            packages = [ (pkgs.callPackage ./OVMF.nix { }) ];
            enable = true;
          };
          swtpm.enable = true;
        };

        hooks.qemu = { win10 = ./win10.sh; };
      };
    };

    users.users.totaltaxamount = {
      extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ];
    };

    programs.virt-manager.enable = true;
    environment.systemPackages = with pkgs; [
      qemu-patched
      virt-manager
      win-virtio
      freerdp
      (pkgs.writeShellScriptBin "rdp-connect" ''
        ${pkgs.freerdp}/bin/xfreerdp /v:$1 /w:1920 /h:1080 /bpp:32 +clipboard +fonts /gdi:hw /rfx /rfx-mode:video /sound:sys:pulse +menu-anims +window-drag /u:$2
      '')
    ];
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;
    boot.kernelPatches = [{
      name = "fake-rdtsc";
      patch = ./linux-fake-rdtsc.patch;
    }];
  };
}
