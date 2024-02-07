{ pkgs, config, ...}:

let
  # Fix werid script thing 
  scriptDir = builtins.dirOf ../../../../dots/eww/scripts/battery; # I hate this
  configDir = pkgs.substituteAllFiles {
    src = ../../../../dots/eww;
    files = [
      "scripts/battery"
      "scripts/mem-ad"
      "scripts/memory"
      "scripts/music_info"
      "scripts/pop"
      "scripts/wifi"
      "scripts/workspaces"

      "images/mic.png"
      "images/music.png"
      "images/profile.png"
      "images/speaker.png"

      "eww.scss"
      "eww.yuck"
      "launch_bar"
    ];
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base05 = "#${config.colorScheme.colors.base05}";
    base08 = "#${config.colorScheme.colors.base08}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0D = "#${config.colorScheme.colors.base0D}";

    font = "${config.font}";
    scriptdir = "${scriptDir}";  # TODO: Why do I have to do it this way??
  };
in
{
  programs.eww = {
    enable = true;
    configDir = configDir.out;
  };

  home.packages = with pkgs; [bc];
}