{ config, ... }:

{
  services = {
    taskserver = {
      enable = true;
      debug = false;
      ipLog = false;
      fqdn = "mail.little-fluffy.cloud";
      listenHost = "mail.little-fluffy.cloud";
      organisations.Public.users = [ "steve" ];
      config = {
        debug.tls = 3;
      };
      pki.manual = {
        server.cert = "/var/lib/taskserver/keys/server.cert";
        server.key = "/var/lib/taskserver/keys/server.key";
        ca.cert = "/var/lib/taskserver/keys/ca.cert.pem";
      };
    };
  };
}

