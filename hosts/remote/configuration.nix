{ config, inputs, lib, user, pkgs, ... }:

let
  user="totaltax";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      inputs.vscode-server.nixosModules.default
    ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  nix.settings.trusted-users = ["totaltax"];
  services.vscode-server.enable = true;


  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Coen Shields";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker"];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl
    sqlite
    pinentry-curses
  ];


  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
  
  networking.nftables.enable = false;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 /* SSH */];
  };

  networking.interfaces.ens18.ipv4.addresses = [{
    address = "10.1.10.104";
    prefixLength = 24;
  }];

  networking.defaultGateway = "10.1.10.1";
  networking.nameservers = [ "1.1.1.1" ];

  # Boot loader
  boot.kernelModules = [ "kvm-amd" "kvm-intel"]; # Needed for vm
  boot.tmp.cleanOnBoot = true;

  # VMs
  virtualisation = {
    docker.enable = true;
  };
}
