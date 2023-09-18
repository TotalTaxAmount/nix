final: prev:
{
  discord = prev.discord.override {
    withVencord = true;
  };

  eww = prev.eww.override  {
    withWayland = true;
  };

  btop = prev.btop.overrideAttrs (old: {
    patches = [./patches/btop_gpu.patch];
  });
}