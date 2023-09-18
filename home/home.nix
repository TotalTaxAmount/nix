{ config, pkgs, inputs, ... }:

let
    user="totaltaxamount";
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
    # sysmontask= pkgs.callPackage ./custom-pkgs/sysmontask.nix {};
    # candy-icons = pkgs.callPackage ./config/icons/candy-icons.nix {};
    myNordTheme = {
      slug = "nord";
      name = "Nord";
      author = "articicestudios (https://github.com/arcticicestudio)";
      colors = {
        # Polar Night
        base00 = "#2E3440";
        base01 = "#3B4252";
        base02 = "#434C5E";
        base03 = "#4C566A";
        # Snow Storm
        base04 = "#D8DEE9";
        base08 = "#E5E9F0"; # Was 05
        base06 = "#ECEFF4";
        # Frost
        base07 = "#8FBCBB";
        base05 = "#88C0D0"; # Was 08
        base09 = "#81A1C1";
        base0A = "#5E81AC";
        #Aurora
        base0B = "#BF616A";
        base0C = "#D08770"; 
        base0D = "#EBCB8B";
        base0E = "#A3BE8C";
        base0F = "#B48EAD";
      };
    };
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

        # Flakes
        inputs.spicetify-nix.homeManagerModule
        inputs.nix-colors.homeManagerModule
  ];

  # System theme
  # Use custom themes defined above or inputs.nix-colors.colorSchemes.THEME themes list at https://github.com/tinted-theming/base16-schemes
  colorScheme = inputs.nix-colors.colorSchemes.tokyodark;

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

  services.dunst = {
	  enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "320";
        offset = "10x4";
        indicate_hidden = true;
        shrink = false;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        gap_size = 5;
        horizontal_padding = 3;
        frame_width = 2;
        frame_color = "#${config.colorScheme.colors.base05}";
        separator_color = "frame";
        sort = true;
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        max_icon_size = 32;
        sticky_history = true;
        history_length = 20;
        always_run_script = true;
        progress_bar = true;
        corner_radius = 8;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
      };
      urgency_low = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 8;
      };
      urgency_normal = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base05}";
        timeout = 8;
      };
      urgency_critical = {
        background = "#${config.colorScheme.colors.base00}";
        foreground = "#${config.colorScheme.colors.base0B}";
        frame_color = "#${config.colorScheme.colors.base0B}";
        timeout = 0;
      };
    };
  };

  programs.git = {
    enable = true;
    userEmail = "shieldscoen@gmail.com";
    userName = "TotalTaxAmount";
  };

  gtk = {
     enable = true;
     theme = { 
        name = "Nordic";
        package = pkgs.nordic;
     };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
