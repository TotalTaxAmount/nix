{
  pkgs,
  config,
  user,
  ...
}:
let
  scriptDir = builtins.dirOf ../../../../dots/eww/scripts/battery.sh;
  ewwCfg = pkgs.substituteAllFiles {
    src = ../../../../dots/eww;
    files = [
      "modules/info.yuck"
      "modules/system.yuck"
      "modules/main.yuck"

      "scripts/battery.sh"
      "scripts/currentapp.sh"
      "scripts/music_utils.sh"
      "scripts/music.sh"
      "scripts/pop.sh"
      "scripts/sys_info.sh"
      "scripts/vpn.sh"
      "scripts/workspaces.sh"

      "eww.scss"
      "eww.yuck"
      "nixos-icon.svg"
    ];
    base00 = "#${config.colorScheme.colors.base00}";
    base03 = "#${config.colorScheme.colors.base03}";
    base05 = "#${config.colorScheme.colors.base05}";
    base08 = "#${config.colorScheme.colors.base08}";
    base0C = "#${config.colorScheme.colors.base0C}";
    base0D = "#${config.colorScheme.colors.base0D}";

    font = "${config.font}";
    scriptdir = "${scriptDir}";
  };
in
{
  # xdg.configFile."eww".source = ewwCfg.out;
  programs.eww = {
    enable = true;
    configDir = ewwCfg.out;
  };
  home.packages = with pkgs; [ bc ];
}

# { pkgs, config, ...}:

# let
#   scriptDir = builtins.dirOf ../../../../dots/eww/scripts/battery.sh; # I hate this
#   configDir = pkgs.substituteAllFiles {
#     src = ../../../../dots/eww;
#     files = [
#       "modules/info.yuck"
#       "modules/system.yuck"
#       "modules/main.yuck"

#       "scripts/battery.sh"
#       "scripts/currentapp.sh"
#       "scripts/music_utils.sh"
#       "scripts/music.sh"
#       "scripts/pop.sh"
#       "scripts/sys_info.sh"
#       "scripts/vpn.sh"
#       "scripts/workspaces.sh"

#       "eww.scss"
#       "eww.yuck"
#       "nixos-icon.svg"
#     ];
#     base00 = "#${config.colorScheme.colors.base00}";
#     base03 = "#${config.colorScheme.colors.base03}";
#     base05 = "#${config.colorScheme.colors.base05}";
#     # base08 = "#${config.colorScheme.colors.base08}";
#     # base0C = "#${config.colorScheme.colors.base0C}";
#     base0D = "#${config.colorScheme.colors.base0D}";

#     font = "${config.font}";
#     scriptdir = "${scriptDir}";  # TODO: Why do I have to do it this way??
#   };
# in{
#   home.file.".config/eww".source = configDir.out;
#   home.packages = with pkgs; [
#     bc
#     eww
#   ];
# }
