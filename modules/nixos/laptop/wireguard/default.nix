{pkgs, config, lib, ...}:

let

in {

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

  systemd.services.wg-quick-wg0.wantedBy = lib.mkForce [ ];
}
