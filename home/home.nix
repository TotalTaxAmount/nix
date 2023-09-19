{ config, pkgs, inputs, ... }:

let
  user="totaltaxamount";
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  candyIcons = pkgs.callPackage ./modules/icons/candy-icons.nix {};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
        ./modules/nvim
        ./modules/hypr
        ./modules/alacritty
        ./modules/rofi
        ./modules/eww
        ./modules/btop
        ./modules/dunst
        ./modules/swaylock

        # Flakes
        inputs.spicetify-nix.homeManagerModule
        inputs.nix-colors.homeManagerModule
  ];

  # System theme
  # Use custom themes defined above or inputs.nix-colors.colorSchemes.THEME themes list at https://github.com/tinted-theming/base16-schemes
  colorScheme = inputs.nix-colors.colorSchemes.material-darker;

  home.username = "totaltaxamount";
  home.homeDirectory = "/home/totaltaxamount";

  # Unfree stuff/Insecure
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "qtwebkit-5.212.0-alpha4"
              ];

  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
   # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Apps
    discord
    gimp
    vscode-fhs
    brave
    fluent-reader
    nomacs
    bottles
    qbittorrent

    #Terminal Apps/Config
    zsh-powerlevel10k
    neofetch
    playerctl

    #Utils
    jq
    socat
    glxinfo
    bat
    openal
    qt5.full
    wget

    #Customization
    nerdfonts
    swww

    # Langs and compilers
    python3
    nodejs
    gcc

    
    # IDEs
    jetbrains.clion
    jetbrains.idea-ultimate

    # Games
    mangohud
    prismlauncher-qt5
    gamemode
    nvtop
    xfce.thunar

    # Screenshot
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    slurp
    wl-clipboard
    libnotify
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idle1timeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # o
  #
  #  /etc/profiles/per-user/totaltaxamount/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Ziro;
    colorScheme = "ziro";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
      songStats
      powerBar
    ];
  };
 
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  programs.git = {
    enable = true;
    userEmail = "shieldscoen@gmail.com";
    userName = "TotalTaxAmount";
  };

  gtk = {
     enable = true;
     iconTheme = { 
        name = "Candy Icons";
        package = candyIcons;
     };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
