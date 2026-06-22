{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  cfg = config.virtualisation.vfio;

  gpuIds = [
    "10de:2860"
    "10de:22bd"
  ];
in
{
  options.virtualisation.vfio = {
    enable = lib.mkEnableOption "VFIO Configuration";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };
    programs.virt-manager.enable = true;

    users.users.${user}.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    environment.systemPackages = [ pkgs.looking-glass-client ];
    specialisation."VFIO".configuration = {
      system.nixos.tags = [ "VFIO" ];

      boot = {
        kernelParams = [
          "amd_iommu=on"
          "iommu=pt"
          "kvm.ignore_msrs=1"
          "vfio-pci.ids=${lib.concatStringsSep "," gpuIds}"
          "vfio_iommu_type1.allow_unsafe_interrupts=1"
        ];

        kernelPatches = [
          {
            name = "bypass-iommu-require-direct"; # TODO: This is scuffed, but it works
            patch = pkgs.writeText "bypass-iommu.patch" ''
              --- a/drivers/iommu/iommu.c
              +++ b/drivers/iommu/iommu.c
              @@ -2404,9 +2404,8 @@
               	if (dev->iommu->require_direct &&
               	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
               	     new_domain == group->blocking_domain)) {
              -		dev_warn(dev,
              -			 "Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.\n");
              -		return -EINVAL;
              +		dev_info(dev,
              +			 "Firmware requested 1:1 mapping, but IOMMU bypass patch is active. Proceeding anyway.\n");
               	}

               	if (dev->iommu->attach_deferred) {
            '';
          }
        ];

        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];

        blacklistedKernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
          "nouveau"
        ];
      };

      systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 ${user} kvm -"
      ];
    };
  };
}
