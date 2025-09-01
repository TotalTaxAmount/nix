{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nvml;

  mypython = pkgs.python311.withPackages (ps: with ps; [
    pynvml
    nvidia-ml-py
  ]);
in {
  options.services.nvml = {
    enable = mkEnableOption "NVML GPU tuning service";

    clockOffset = mkOption {
      type = types.int;
      default = 0;
      description = "Core clock offset in MHz";
    };

    memOffset = mkOption {
      type = types.int;
      default = 0;
      description = "Memory clock offset in MHz (must be doubled for NVML)";
    };

    powerLimit = mkOption {
      type = types.int;
      default = 0;
      description = "Power limit in milliwatts (0 = skip)";
    };

    gpuIndex = mkOption {
      type = types.int;
      default = 0;
      description = "The index of the GPU";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nvml-tune = {
      description = "NVML GPU tuning service";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${mypython}/bin/python3 ${pkgs.writeText "nvml-tune.py" ''
          from pynvml import *
          import sys

          CORE_OFFSET = ${toString cfg.clockOffset}
          MEM_OFFSET = ${toString cfg.memOffset}
          POWER_LIMIT = ${toString cfg.powerLimit}
          GPU_INDEX = ${toString cfg.gpuIndex}

          try:
              nvmlInit()
              h = nvmlDeviceGetHandleByIndex(GPU_INDEX)
              if CORE_OFFSET != 0:
                  nvmlDeviceSetGpcClkVfOffset(h, CORE_OFFSET)
              if MEM_OFFSET != 0:
                  nvmlDeviceSetMemClkVfOffset(h, MEM_OFFSET)
              if POWER_LIMIT != 0:
                  max_pl = nvmlDeviceGetPowerManagementLimitConstraints(h)[1]
                  nvmlDeviceSetPowerManagementLimit(h, min(POWER_LIMIT, max_pl))
              nvmlShutdown()
              print(f"[info] Success for gpu {GPU_INDEX}. core_offset: {CORE_OFFSET}, mem_offset: {MEM_OFFSET}, power_limit: {POWER_LIMIT}")
          except Exception as e:
              print("[error] NVML tuning failed:", e, file=sys.stderr)
              sys.exit(1)
        ''}";
      };
    };
  };
}
