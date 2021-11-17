{ config, ... }:

{
  imports =
    [
      (builtins.fetchTarball {
          url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-21.05/nixos-mailserver-nixos-21.05.tar.gz";
          sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
      })
    ];

  mailserver = {
    enable = true;
    fqdn = "mail.little-fluffy.cloud";
    domains = [ "little-fluffy.cloud" "scooby.little-fluffy.cloud" "fluffy-little.cloud" ];

    # A list of all login accounts. To create the password hashes, use
    # mkpasswd -m sha-512 "super secret password"
    loginAccounts = {
        "steve@little-fluffy.cloud" = {
            hashedPassword = "$6$JP4YI90.Zley$0UOShElbb8qNndanXmlIiq3ASQhRqzwnpoaMopnZL8LWniYHHnbMbQ4cKCU9b4z3HMmGWke0pw0RiJWvTII.P/";

            aliases = [
                "postmaster@little-fluffy.cloud"
            ];

            # Make this user the catchAll address for domains little-fluffy.cloud
            catchAll = [
              "little-fluffy.cloud"
              "fluffy-little.cloud"
            ];
        };

        "monit@scooby.little-fluffy.cloud" = {
            hashedPassword = "$6$nWSLeS8kRWL$IPpKa9SZlMJ8/Q/hy28BUSIrrODhVSeprc34Mf/Qbr5PrLEB09rRzmBj9hbAlxr6pg.h329nXIHA/HxsuQ7N4.";
        };

        "alerts@scooby.little-fluffy.cloud" = {
            hashedPassword = "$6$VlvVu5JEWEmUEHw$mQtUeYz9FZmO2b1kR9rqe09y/DBwhATM4WdcDKLnn07kQQ5XdozdcQRoGAPoDn4IbBisS5CWLmrw1aa6IUPeh.";
        };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;

    monitoring = {
      enable = true;
      alertAddress = "monit@little-fluffy.cloud";
    };

    borgbackup = {
      enable = true;
      startAt = "weekly";
      #repoLocation = "de1576@de1576.rsync.net:mail.little-fluffy.cloud/mail";
    };
  };

  services.roundcube = {
      enable = true;
      hostName = "mail.little-fluffy.cloud";
      extraConfig = ''
        $config['smtp_server'] = "tls://%n";
      '';
  };

  security.acme = {
    email = "postmaster@little-fluffy.cloud";
    acceptTerms = true;

    certs = {
      "mail.little-fluffy.cloud".email = "postmaster@little-fluffy.cloud";
    };
  };
}

