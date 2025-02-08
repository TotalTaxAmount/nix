{
  user,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware.nix
  ];

  nix.settings.trusted-users = [ user ];

  users.users.${user} = {
    isNormalUser = true;
    description = "Coen Shields";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
    ];
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.X11Forwarding = true;
      extraConfig = ''
        X11DisplayOffset 10
      '';
    };

    openvscode-server = {
      enable = true;
    };

    xserver = {
      enable = true;
      autorun = true;

      displayManager.startx.enable = true;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH
      ];
    };

    interfaces.ens18.ipv4.addresses = [
      {
        address = "10.1.10.104";
        prefixLength = 24;
      }
    ];

    defaultGateway = "10.1.10.1";
    nameservers = [ "1.1.1.1" ];
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  programs.gnupg.agent = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    sqlite
    pinentry-curses
    nodejs_20
  ];

  # Boot loader
  boot.kernelModules = [
    "kvm-intel"
  ];

  boot.tmp.cleanOnBoot = true;

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
