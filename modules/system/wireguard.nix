{pkgs, config, lib, ...}:

let

in {
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = lib.mkOverride 98 true;
    "net.ipv4.conf.default.forwarding" = lib.mkOverride 98 true;
  };

  networking.firewall.allowedUDPPorts = [ 51820 /* Wireguard VPN */ ];
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.1.11.2/24" ];
      dns = [ "1.1.1.1" ];
      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          publicKey = "kE24u6RmvQDkOT8JSgx7tHzkwkeRywh8ofA6NLel9z0=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "totaltax.ddns.net:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # networking.wireguard.enable = true;
  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.1.11.2/24" ];

  #     listenPort = 51820;


  #     # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
  #     postSetup = ''
  #       ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
  #       ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.1.11.2/24 -o wlp3s0 -j MASQUERADE
  #     '';

  #     # Undo the above
  #     postShutdown = ''
  #       ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
  #       ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.1.11.2/24 -o wlp3s0 -j MASQUERADE
  #     '';

  #     privateKeyFile = config.sops.secrets."wireguard/private_key".path;

  #     peers = [
  #       {
  #         publicKey = "kE24u6RmvQDkOT8JSgx7tHzkwkeRywh8ofA6NLel9z0=";
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         endpoint = "totaltax.ddns.net:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
}
