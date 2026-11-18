{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.nix-colors.homeManagerModule ];

  config = {
    colorScheme = inputs.nix-colors.colorSchemes.twilight;

    # Headless host: skip the nix-colors GTK theme build (its old
    # `nodePackages.sass` reference no longer exists in current nixpkgs).
    gtk.theme = {
      package = null;
      name = "Adwaita-dark";
    };

    # Headless host: a graphical pinentry cannot be shown over SSH/TTY.
    services.gpg-agent.pinentry.package = pkgs.pinentry-curses;
  };
}
