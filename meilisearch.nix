{ config, ... }:

{
  security.acme = {
    email = "postmaster@little-fluffy.cloud";
    acceptTerms = true;

    certs = {
      "meilisearch.little-fluffy.cloud".email = "postmaster@little-fluffy.cloud";
      "meilisearch.little-fluffy.cloud".webroot = "/var/lib/acme";
      #"meilisearch.little-fluffy.cloud".webroot = "/var/lib/acme/acme-challenge";
    };

  };

  services = {
    meilisearch = {
      enable = true;
      listenAddress = "127.0.0.1"; # Default, only listen on localhost
      listenPort = 7700; # Default
      environment = "production";
      masterKeyEnvironmentFile = "/root/meili_master_key";
      noAnalytics = true; # Default
    };

    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # other Nginx options
      virtualHosts."meilisearch.little-fluffy.cloud" =  {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7700";
          proxyWebsockets = false;
        };
      };
    };
  };
}
