{pkgs, config, inputs, ...}:

let

in {
  imports = [
    inputs.nix-colors.homeManagerModule
  ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.twilight;

    home.packages = with pkgs; [
      brave
    ];

    # home.file.".xinitrc".text = ''
    #   if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    #     eval $(dbus-launch --exit-with-session --sh-syntax)
    #   fi
    #   systemctl --user import-environment DISPLAY XAUTHORITY

    #   if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    #           dbus-update-activation-environment DISPLAY XAUTHORITY
    #   fi
    # '';
  };
}
