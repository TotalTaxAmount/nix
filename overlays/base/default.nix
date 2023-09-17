final: prev:
{
  discord = prev.discord.overrideAttrs (old: {
    withVencord = true;
  });
}