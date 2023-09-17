final: prev:
{
  discord = prev.discord.override {
    withVencord = true;
  };

  eww = prev.eww.override  {
    withWayland = true;
  };
}