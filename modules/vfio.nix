{
  pkgs,
  ...
}:
let
  # https://gitlab.com/risingprismtv/single-gpu-passthrough/-/blob/master/hooks/vfio-startup?ref_type=heads 
  vfioStartup = pkgs.writeScriptBin "vfio-startup" ''
    #!${pkgs.bash}/bin/bash
    DATE=$(date +"%m/%d/%Y %R:%S :")

    ## Sets dispmgr var as null ##
    DISPMGR="null"

    ################################## Script ###################################
    echo "$DATE Beginning of Startup!"

    function stop_display_manager_if_running {
        ## Get display manager on systemd based distros ##
        if [[ -x /run/systemd/system ]] && echo "$DATE Distro is using Systemd"; then
            DISPMGR="$(grep 'ExecStart=' /etc/systemd/system/display-manager.service | awk -F'/' '{print $(NF-0)}')"
            echo "$DATE Display Manager = $DISPMGR"

            ## Stop display manager using systemd ##
            if systemctl is-active --quiet "$DISPMGR.service"; then
                grep -qsF "$DISPMGR" "/tmp/vfio-store-display-manager" || echo "$DISPMGR" >/tmp/vfio-store-display-manager
                ${pkgs.systemd}/bin/systemctl stop "$DISPMGR.service"
                ${pkgs.systemd}/bin/systemctl isolate multi-user.target
            fi

            while ${pkgs.systemd}/bin/systemctl is-active --quiet "$DISPMGR.service"; do
                sleep "1"
            done

            return

        fi

    }


    ## Unbind EFI-Framebuffer ##
    if test -e "/tmp/vfio-is-nvidia"; then
        rm -f /tmp/vfio-is-nvidia
        else
            test -e "/tmp/vfio-is-amd"
            rm -f /tmp/vfio-is-amd
    fi

    sleep "1"

    ##############################################################################################################################
    ## Unbind VTconsoles if currently bound (adapted and modernised from https://www.kernel.org/doc/Documentation/fb/fbcon.txt) ##
    ##############################################################################################################################
    if test -e "/tmp/vfio-bound-consoles"; then
        rm -f /tmp/vfio-bound-consoles
    fi
    for (( i = 0; i < 16; i++))
    do
      if test -x /sys/class/vtconsole/vtcon"$${i}"; then
          if [ "$(grep -c "frame buffer" /sys/class/vtconsole/vtcon"$${i}"/name)" = 1 ]; then
            echo 0 > /sys/class/vtconsole/vtcon"$${i}"/bind
              echo "$DATE Unbinding Console $${i}"
              echo "$i" >> /tmp/vfio-bound-consoles
          fi
      fi
    done

    sleep "1"

    if lspci -nn | grep -e VGA | grep -s NVIDIA ; then
        echo "$DATE System has an NVIDIA GPU"
        grep -qsF "true" "/tmp/vfio-is-nvidia" || echo "true" >/tmp/vfio-is-nvidia
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

        ## Unload NVIDIA GPU drivers ##
        modprobe -r nvidia_uvm
        modprobe -r nvidia_drm
        modprobe -r nvidia_modeset
        modprobe -r nvidia
        modprobe -r i2c_nvidia_gpu
        modprobe -r drm_kms_helper
        modprobe -r drm

        echo "$DATE NVIDIA GPU Drivers Unloaded"
    fi

    ## Load VFIO-PCI driver ##
    modprobe vfio
    modprobe vfio_pci
    modprobe vfio_iommu_type1

    echo "$DATE End of Startup!"
  ''; 

  # https://gitlab.com/risingprismtv/single-gpu-passthrough/-/blob/master/hooks/vfio-teardown?ref_type=heads
  vfioTeardown = pkgs.writeScriptBin "vfio-teardown" ''
    #!${pkgs.bash}/bin/bash

    DATE=$(date +"%m/%d/%Y %R:%S :")

    ################################## Script ###################################

    echo "$DATE Beginning of Teardown!"

    ## Unload VFIO-PCI driver ##
    modprobe -r vfio_pci
    modprobe -r vfio_iommu_type1
    modprobe -r vfio

    if grep -q "true" "/tmp/vfio-is-nvidia" ; then

        ## Load NVIDIA drivers ##
        echo "$DATE Loading NVIDIA GPU Drivers"
        
        modprobe drm
        modprobe drm_kms_helper
        modprobe i2c_nvidia_gpu
        modprobe nvidia
        modprobe nvidia_modeset
        modprobe nvidia_drm
        modprobe nvidia_uvm

        echo "$DATE NVIDIA GPU Drivers Loaded"
    fi

    ## Restart Display Manager ##
    input="/tmp/vfio-store-display-manager"
    while read -r DISPMGR; do
      echo "$DATE Var has been collected from file: $DISPMGR"

      ${pkgs.systemd}/bin/systemctl start "$DISPMGR.service"
    done < "$input"

    ############################################################################################################
    ## Rebind VT consoles (adapted and modernised from https://www.kernel.org/doc/Documentation/fb/fbcon.txt) ##
    ############################################################################################################

    input="/tmp/vfio-bound-consoles"
    while read -r consoleNumber; do
      if test -x /sys/class/vtconsole/vtcon"$${consoleNumber}"; then
          if [ "$(grep -c "frame buffer" "/sys/class/vtconsole/vtcon$${consoleNumber}/name")" \
              = 1 ]; then
        echo "$DATE Rebinding console $${consoleNumber}"
        echo 1 > /sys/class/vtconsole/vtcon"$${consoleNumber}"/bind
          fi
      fi
    done < "$input"


    echo "$DATE End of Teardown!"
  '';

  # 
  qemu = pkgs.writeScriptBin "qemu" ''
   #!${pkgs.bash}/bin/bash

    OBJECT="$1"
    OPERATION="$2"

    if [[ $OBJECT == "win10" ]]; then
      case "$OPERATION" in
              "prepare")
                    ${pkgs.systemd}/bin/systemctl start libvirt-nosleep@"$OBJECT"  2>&1 | tee -a /var/log/libvirt/custom_hooks.log
                    ${vfioStartup}/bin/vfio-startup 2>&1 | tee -a /var/log/libvirt/custom_hooks.log
                    ;;

                    "release")
                    ${pkgs.systemd}/bin/systemctl stop libvirt-nosleep@"$OBJECT"  2>&1 | tee -a /var/log/libvirt/custom_hooks.log  
                    ${vfioTeardown}/bin/vfio-teardown 2>&1 | tee -a /var/log/libvirt/custom_hooks.log
                    ;;
      esac
    fi
 
  '';
in
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };


  systemd.services."libvirt-no-sleep@" = {
    description = "Preventing sleep while libvirt domain %i is running";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.systemd}/bin/systemd-inhibit \
          --what=sleep \
          --why=Libvirt domain "%i" is running \
          --who=%u \
          --mode=block \
          ${pkgs.coreutils}/bin/sleep infinity
      '';
    };
  };

  system.activationScripts.libvirtHook = {
    text = ''
      ln -s ${qemu}/bin/qemu /var/lib/libvirtd/hooks/qemu.d/hook.sh
    '';
  };
}
